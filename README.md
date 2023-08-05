# Simulation Waveform
Because the algorithm contains thousands of states and hundreds of pixels, it is infeasible to show them all. We present the initialization and 10 time points when each probability was computed and compared, verifying that our neural network worked. The shown prediction was on an image containing number 5.

## Initialization
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/22ab46d5-8bb0-4163-ba83-b68b5d8cf9fb)

RESET was set high, then NN_START was set to high. After INIT, probs, old_probs and prediction were initialized. old_probs was initialized to lower bound of 32-bit number to ensure it was less than first probability.

## Probability of number 0
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/779b0899-89eb-4d5c-86ca-fade066aa26c)

The probability of number 0 was -63111, larger than old_probs, so it was updated. Prediction was initialized as 0, so it seemed unchanged.

## Probability of number 1
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/aeef0005-72b8-4e1e-8318-918bdcfc3fd0)

The probability of number 1 was -66647, less than old_probs, so nothing was changed.

## Probability of number 2
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/1c96ac58-bc93-468e-9649-68ca82ac1c7a)

The probability of number 2 was -61740, larger than old_probs, so it was updated. Prediction was also updated.

## Probability of number 3
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/47f7bc8d-4d2f-42e4-9f06-4fdef56fb09e)

The probability of number 3 was -72842, less than old_probs, so nothing was changed.

## Probability of number 4
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/02a757bd-7d69-4484-bc03-27af4cbada81)

The probability of number 4 was -84968, less than old_probs, so nothing was changed.

## Probability of number 5
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/62365cce-51c9-4ed2-8f9f-820b970ce4a2)

The probability of number 5 was -34913, larger than old_probs, so it was updated as well as the prediction.

## Probability of number 6
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/466ee7d5-c69e-4c73-971c-c8ebba6b4ef9)

The probability of number 6 was -45875, less than old_probs, so nothing was changed.

## Probability of number 7
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/7abcd6e5-f734-462e-9542-7b1e4a9f8be5)

The probability of number 7 was -100205, less than old_probs, so nothing was changed.

## Probability of number 8
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/121b1e17-e357-4766-9b3e-9cdffea832fc)

The probability of number 8 was -45871, less than old_probs, so nothing was changed.

## Probability of number 9
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/b1ac3b06-5a58-480e-8b41-f3df70ea27fa)

The probability of number 9 was -66536, less than old_probs, so nothing was changed. Besides, the simulation time for one prediction was not its actual running time because it did not need to consider timing constraints. At last, the prediction was 5 and NN_DONE was set high.

The Python code of the neural network algorithm and its speed test are as follows:
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/38f84e26-4be1-4f30-b0e4-9f3c89b943b0)
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/e5b07dd5-445b-41eb-ba8e-0dcb1f9e688f)

# Design statistics and Discussions

| Item | Statistics |
| --- | --- |
| LUT	| 36936 |
| DSP	| 8 |
| memory bits	| 0 |
| flip-flop	| 25185 |
| frequency MHz | 47.43 |
| static power mW	| 194.77 |
| dynamic power mW | 102.92 |
| total power mW | 297.69 |

The theoretical time for it to run one prediction, estimated by (number of states)/Fmax, was about 0.442 ms. The time of software version was about 42.3 ms. The current design focused on saving area. If needed, area can be exchanged for further acceleration using parallel computation on different convolutional kernel positions, pixels and numbers. 

# Conclusion
We have realized a hardware acceleration of convolutional neural network algorithm on number recognition. It is 100 times faster than the software operations. Our design was focused on saving area due to initial overflow of resources in Quartus, but it was still significantly faster than the software. Therefore, it is both area-concerned and fast. It has great potential to be further accelerated by trading area. Besides, this neural network model can be used as a submodule. It is capable of being integrated into more sophisticated designs. We have gained useful experience in accelerating neural network models.
