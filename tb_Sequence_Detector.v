module tb_Sequence_Detector();

  // Inputs - test stimulus signals
  reg sequence_in;
  reg clock;
  reg reset;

  // Output - verification signals
  wire detector_out;

  // Instantiate the Sequence Detector Module
  Sequence_Detector_MOORE uut (
    .sequence_in(sequence_in),
    .clock(clock),
    .reset(reset),
    .detector_out(detector_out)
  );

  // Clock generation
  initial begin
    clock = 0;
    forever #5 clock = ~clock;  // 10ns clock period
  end

  // Test stimulus generation
  initial begin
    // Initialize inputs
    sequence_in = 0;
    reset = 1;      // Apply reset
    
    // Wait for global reset
    #30;
    reset = 0;      // Release reset
    
    // Apply test sequence to detect "1011"
    #10 sequence_in = 1;  // 1
    #10 sequence_in = 0;  // 0
    #10 sequence_in = 1;  // 1
    #10 sequence_in = 1;  // 1 - Pattern complete, expect output=1
    
    // Test overlapping sequence "101101"
    #10 sequence_in = 0;  // 0
    #10 sequence_in = 1;  // 1
    
    // Run simulation for a while longer
    #50;
    $finish;        // End simulation
  end
  
  // Monitor for verification
  initial begin
    $monitor("Time=%0t | Input=%b | State=%b | Output=%b",
             $time, sequence_in, uut.current_state, detector_out);
  end
endmodule
