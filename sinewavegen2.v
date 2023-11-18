module hardware_nco_sine_fast_phase(  
  input clk_100M,      // 100MHz clock input
  input clk_200M,      // 200MHz clock input
  input clk_96k,       // 96kHz clock input
  input sample_interrupt, // Input signal for sample interrupt
  input [3:0] wave_select, // 4-bit input for waveform selection
  input [5:0] step_size,   // 6-bit input for step size
  input [7:0] phase,       // 8-bit input for phase
  output output_enable,     // Output signal to enable output
  output[23:0] sample );    // 24-bit output for the sample

 reg signed[23:0] sine_sample;      // 24-bit signed register for sine sample
 reg[23:0] syncronous_sample;       // 24-bit register for synchronous sample
 wire[23:0] unscaled_sample;        // 24-bit wire for unscaled sample
 wire[2:0] active_waveforms;        // 3-bit wire for active waveforms
 reg [%i:0] sample_count;           // Register for sample count
 wire [%i:0] sample_count_phased;   // Wire for phased sample count

 // Phased sample count calculation
 assign sample_count_phased = sample_count + {phase[6:0], %i''b0}; 

 // Create 1ns pulse from 96kHz clock  
 reg clk_96k_q;  
 reg clk_96k_qq;  
 wire clk_96_pulse;  
 always @(posedge clk_100M) begin  
    clk_96k_q <= clk_96k;  
    clk_96k_qq <= clk_96k_q;  
 end  
 assign clk_96_pulse = (clk_96k_q && ~(clk_96k_qq));   

 // Create 1ns pulse from interrupt signal  
 reg interrupt_q;  
 reg interrupt_qq;  
 wire interrupt_pulse;  
 always @(posedge clk_100M) begin  
    interrupt_q <= sample_interrupt;  
    interrupt_qq <= interrupt_q;  
 end  
 assign interrupt_pulse = (interrupt_q && ~(interrupt_qq));   
 
 always @(posedge clk_100M) begin
    // Sample count increment based on step size
    if(interrupt_pulse)
        sample_count = sample_count + step_size;
    else
        sample_count = sample_count;
 end

 always @(posedge clk_200M) begin
    // Sine sample calculation based on phased sample count
    case(sample_count_phased) 
        %i: sine_sample = %i; 
        default: sine_sample = 24''b0;  
    endcase;
 end

 always @(posedge clk_100M) begin
    // Synchronous sample update based on 96kHz pulse
    if(clk_96_pulse)
        syncronous_sample = sine_sample;
    else
        syncronous_sample = syncronous_sample;   
 end

 // Unscaled sample based on waveform selection
 assign unscaled_sample = (wave_select[0]) ? syncronous_sample : 24''b0;

 // Active waveforms calculation
 assign active_waveforms = wave_select[0] + wave_select[1] + wave_select[2] + wave_select[3];

 // Sample output based on active waveforms
 assign sample = (active_waveforms == 1) ? {unscaled_sample[23], unscaled_sample[20:0], 2''b0} : 
                (active_waveforms == 2) ? {unscaled_sample[23:22], unscaled_sample[20:0], 1''b0} : 
                (active_waveforms == 3) ? {unscaled_sample[23:22], unscaled_sample[20:0], 1''b0} : 
                (active_waveforms == 4) ? unscaled_sample : 24''b0;

 // Output enable based on 96kHz pulse
 assign output_enable = clk_96_pulse;

endmodule
