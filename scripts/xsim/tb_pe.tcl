add_wave tb_pe/clk
add_wave tb_pe/intf/reset_n
add_wave_divider
add_wave tb_pe/intf/mode
add_wave_divider
add_wave tb_pe/intf/weight_in
add_wave tb_pe/intf/activation_in
add_wave tb_pe/intf/psum_in
add_wave_divider
add_wave tb_pe/intf/activation_out
add_wave tb_pe/intf/psum_out
add_wave_divider
add_wave tb_pe/dut/weight_reg
add_wave tb_pe/dut/product

run all
