`default_nettype none // Overrides default behavior (in a good way)

module main(clk, switch_input, switch_error, correct_parity, errored_message, correct_output);
// module main(clk, switch_input, switch_error, correct_parity, errored_message);

//Module I/O and parameters
parameter N = 4; // num message bits
parameter M = 3; // num parity bits
input wire clk;
input wire [N-1:0] switch_input; 
input wire [N+M-1:0] switch_error; 
output logic [M-1:0] correct_parity; 
output logic [N+M-1:0] errored_message; 
output logic [N-1:0] correct_output; 
logic [M-1:0] error_indicator; 

always_comb begin
    correct_parity[0] = switch_input[0] ^ switch_input[1] ^ switch_input[3];
    correct_parity[1] = switch_input[0] ^ switch_input[2] ^ switch_input[3];
    correct_parity[2] = switch_input[1] ^ switch_input[2] ^ switch_input[3];
end

always_comb begin
    errored_message = {correct_parity, switch_input} ^ switch_error;
end

always_comb begin
    error_indicator[0] = correct_parity[0] ^ errored_message[0] ^ errored_message[1] ^ errored_message[3];
    error_indicator[1] = correct_parity[1] ^ errored_message[0] ^ errored_message[2] ^ errored_message[3];
    error_indicator[2] = correct_parity[2] ^ errored_message[1] ^ errored_message[2] ^ errored_message[3];
end

always_comb begin
    correct_output[0] = errored_message[0] ^ (error_indicator[0] & error_indicator[1] & ~error_indicator[2]);
    correct_output[1] = errored_message[1] ^ (error_indicator[0] & ~error_indicator[1] & error_indicator[2]);
    correct_output[2] = errored_message[2] ^ (~error_indicator[0] & error_indicator[1] & error_indicator[2]);
    correct_output[3] = errored_message[3] ^ (error_indicator[0] & error_indicator[1] & error_indicator[2]);
end

endmodule

`default_nettype wire // Re-engages default behaviour, needed when using other designs that expect it.
