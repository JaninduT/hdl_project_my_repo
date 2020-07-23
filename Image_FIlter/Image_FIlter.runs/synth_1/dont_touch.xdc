# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# IP: ip/axi_uartlite_unit/axi_uartlite_unit.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==axi_uartlite_unit || ORIG_REF_NAME==axi_uartlite_unit} -quiet] -quiet

# IP: ip/padded_image_ram/padded_image_ram.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==padded_image_ram || ORIG_REF_NAME==padded_image_ram} -quiet] -quiet

# IP: ip/input_output_ram/input_output_ram.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==input_output_ram || ORIG_REF_NAME==input_output_ram} -quiet] -quiet

# XDC: ip/axi_uartlite_unit/axi_uartlite_unit_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==axi_uartlite_unit || ORIG_REF_NAME==axi_uartlite_unit} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: ip/axi_uartlite_unit/axi_uartlite_unit_ooc.xdc

# XDC: ip/axi_uartlite_unit/axi_uartlite_unit.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==axi_uartlite_unit || ORIG_REF_NAME==axi_uartlite_unit} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: ip/padded_image_ram/padded_image_ram_ooc.xdc

# XDC: ip/input_output_ram/input_output_ram_ooc.xdc
