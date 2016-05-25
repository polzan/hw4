%% coding

enc= fec.ldpcenc; % Construct a default LDPC encoder object 
% Construct a companion LDPC decoder object
dec= fec.ldpcdec;
dec.DecisionType= 'Hard decision';
dec.OutputFormat = 'Information part';
dec.NumIterations= 50;
% Stop if all parity-checks are satisfied 
dec.DoParityChecks= 'Yes'; 
% Generate and encode a random binary message
msg= randi([0 1],1,enc.NumInfoBits);
codeword= encode(enc,msg); 
% Construct a BPSK modulator object
modObj= modem.pskmod('M',4,'InputType','Bit'); 
% Modulate the signal (map bit 0 to 1 + 0i, bit 1 to -1 + 0i)
modulatedsig= modulate(modObj, transpose(codeword)); 
% Noise parameters 
SNRdB=  2.5; sigma = sqrt(10^(-SNRdB/10)); 
% Transmit signal through AWGN channel
receivedsig= awgn(modulatedsig, SNRdB, 0); ... 
% Construct a BPSK demodulator object to compute % log-likelihood ratios
demodObj = modem.pskdemod(modObj,'DecisionType','LLR', 'NoiseVariance',sigma^2); 
% Compute log-likelihood ratios (AWGN channel)
llr = demodulate(demodObj, receivedsig); 

% Decode received signal
decodedmsg = decode(dec, transpose(llr)); 
% Actual number of iterations executed
disp(['Number of iterations executed = '  num2str(dec.ActualNumIterations)]); 
 % Number of parity-checks violated
 disp(['Number of parity-checks violated = ' num2str(sum(dec.FinalParityChecks))]); 
 % Compare with original message
 disp(['Number of bits incorrectly decoded = '  num2str(nnz(decodedmsg-msg))]); 