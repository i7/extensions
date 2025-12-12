# Invalid split method

By the time the `FW_ConstructGlkWindow` runs, the split method must be a valid method, not `inherited`. This will normally be the case, unless the before constructing rules are altered.