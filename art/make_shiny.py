import struct, zlib, colorsys, shutil

SRC = '/Users/mathiasmoen/repo/prosjekt Y/art/william/art/torsk.aseprite'
DST = '/Users/mathiasmoen/repo/prosjekt Y/art/william/art/torsk_shiny.aseprite'

HUE_SHIFT = 160 / 360.0   # ~160 degrees -> brown becomes teal/blue-green
SAT_BOOST = 1.4             # punch up saturation


def shift_color(r, g, b):
    if r == g == b == 0:
        return r, g, b
    h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
    h = (h + HUE_SHIFT) % 1.0
    s = min(1.0, s * SAT_BOOST)
    nr, ng, nb = colorsys.hsv_to_rgb(h, s, v)
    return int(nr * 255), int(ng * 255), int(nb * 255)


data = bytearray(open(SRC, 'rb').read())

nchunks = struct.unpack_from('<H', data, 128 + 6)[0]
chunk_off = 128 + 16

for _ in range(nchunks):
    chunk_size = struct.unpack_from('<I', data, chunk_off)[0]
    chunk_type = struct.unpack_from('<H', data, chunk_off + 4)[0]

    # --- Palette chunk (0x2019) ---
    if chunk_type == 0x2019:
        n_entries = struct.unpack_from('<I', data, chunk_off + 6)[0]
        first_idx = struct.unpack_from('<I', data, chunk_off + 10)[0]
        last_idx  = struct.unpack_from('<I', data, chunk_off + 14)[0]
        p = chunk_off + 26  # after 8 reserved bytes
        for _ in range(last_idx - first_idx + 1):
            flags = struct.unpack_from('<H', data, p)[0]
            r, g, b, a = data[p+2], data[p+3], data[p+4], data[p+5]
            if a > 0:
                nr, ng, nb = shift_color(r, g, b)
                data[p+2], data[p+3], data[p+4] = nr, ng, nb
            p += 6
            if flags & 1:  # has name — skip STRING (WORD len + bytes)
                name_len = struct.unpack_from('<H', data, p)[0]
                p += 2 + name_len

    # --- Old palette chunk (0x0004) ---
    elif chunk_type == 0x0004:
        n_packets = struct.unpack_from('<H', data, chunk_off + 6)[0]
        p = chunk_off + 8
        for _ in range(n_packets):
            skip = data[p]
            n_cols = data[p+1] if data[p+1] != 0 else 256
            p += 2
            for _ in range(n_cols):
                r, g, b = data[p], data[p+1], data[p+2]
                nr, ng, nb = shift_color(r, g, b)
                data[p], data[p+1], data[p+2] = nr, ng, nb
                p += 3

    # --- Cel chunk (0x2005) with compressed pixels ---
    elif chunk_type == 0x2005:
        cel_type = struct.unpack_from('<H', data, chunk_off + 13)[0]
        if cel_type == 2:
            w = struct.unpack_from('<H', data, chunk_off + 22)[0]
            h = struct.unpack_from('<H', data, chunk_off + 24)[0]
            compressed = bytes(data[chunk_off + 26:chunk_off + chunk_size])
            pixels = bytearray(zlib.decompress(compressed))
            for p in range(w * h):
                r, g, b, a = pixels[p*4], pixels[p*4+1], pixels[p*4+2], pixels[p*4+3]
                if a > 0:
                    nr, ng, nb = shift_color(r, g, b)
                    pixels[p*4], pixels[p*4+1], pixels[p*4+2] = nr, ng, nb
            new_compressed = zlib.compress(bytes(pixels))
            # Rebuild chunk data
            new_chunk_size = 26 + len(new_compressed)
            struct.pack_into('<I', data, chunk_off, new_chunk_size)
            data[chunk_off + 26:chunk_off + chunk_size] = new_compressed
            chunk_size = new_chunk_size  # use updated size for next offset

    chunk_off += chunk_size

# Update file size in header
struct.pack_into('<I', data, 0, len(data))
# Update frame size
frame_size = len(data) - 128
struct.pack_into('<I', data, 128, frame_size)

open(DST, 'wb').write(data)
print(f'Written: {DST}')
print(f'Original: {len(open(SRC,"rb").read())} bytes -> Shiny: {len(data)} bytes')
