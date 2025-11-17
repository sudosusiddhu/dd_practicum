module Sequence_Detector_MEALY(
  input clock,        // clock signal
  input reset,        // reset input
  input sequence_in,  // binary input
  output reg detector_out  // output of the sequence detector
);

  // State parameters (Mealy needs fewer states than Moore)
  parameter IDLE = 2'b00,
            S1 = 2'b01,
            S10 = 2'b10,
            S101 = 2'b11;

  reg [1:0] current_state, next_state; // current state and next state

  // Sequential memory of the Mealy FSM
  always @(posedge clock, posedge reset) begin
    if(reset==1) 
      current_state <= IDLE; // reset to initial state
    else
      current_state <= next_state; // otherwise, update to next state
  end
  
  // Combinational logic for next state and output (combined in Mealy)
  always @(current_state, sequence_in) begin
    // Default output (prevent latches)
    detector_out = 1'b0;
    
    case(current_state)
      IDLE: begin
        if(sequence_in == 1) begin
          next_state = S1;
          detector_out = 1'b0;
        end else begin
          next_state = IDLE;
          detector_out = 1'b0;
        end
      end
      
      S1: begin
        if(sequence_in == 0) begin
          next_state = S10;
          detector_out = 1'b0;
        end else begin
          next_state = S1;
          detector_out = 1'b0;
        end
      end
      
      S10: begin
        if(sequence_in == 1) begin
          next_state = S101;
          detector_out = 1'b0;
        end else begin
          next_state = IDLE;
          detector_out = 1'b0;
        end
      end
      
      S101: begin
        if(sequence_in == 1) begin
          next_state = S1;      // Return to S1 for overlapping sequences
          detector_out = 1'b1;  // Output 1 when full sequence 1011 detected
        end else begin
          next_state = S10;
          detector_out = 1'b0;
        end
      end
      
      default: begin
        next_state = IDLE;
        detector_out = 1'b0;
      end
    endcase
  end
endmodule
