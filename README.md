# Simulation Waveform
Because the algorithm contains thousands of states and hundreds of pixels, it is infeasible to show them all. We present the initialization and 10 time points when each probability was computed and compared, verifying that our neural network worked. The shown prediction was on an image containing number 5.

## Initialization
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/5add9ad7-9303-4c17-b685-0b4409101219)

RESET was set high, then NN_START was set to high. After INIT, probs, old_probs and prediction were initialized. old_probs was initialized to lower bound of 32-bit number to ensure it was less than first probability.

## Probability of number 0
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/082b226d-9c03-4537-ab2c-13f4609fc821)

The probability of number 0 was -63111, larger than old_probs, so it was updated. Prediction was initialized as 0, so it seemed unchanged.

## Probability of number 1
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/256d115d-ad0d-4abd-95a0-083644ec8cb5)

The probability of number 1 was -66647, less than old_probs, so nothing was changed.

## Probability of number 2
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/e929488c-6fb0-4b12-af46-b91fb997d6f4)

The probability of number 2 was -61740, larger than old_probs, so it was updated. Prediction was also updated.

## Probability of number 3
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/89b6b420-3fa3-4e44-bcee-dd58c188c696)

The probability of number 3 was -72842, less than old_probs, so nothing was changed.

## Probability of number 4
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/ac10d21b-1436-49cc-a66b-47c8caa5e345)

The probability of number 4 was -84968, less than old_probs, so nothing was changed.

## Probability of number 5
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/2224533d-fa1c-4991-8a47-64436045c37f)

The probability of number 5 was -34913, larger than old_probs, so it was updated as well as the prediction.

## Probability of number 6
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/b846494a-2b2d-45bf-98ab-50550d1e737f)

The probability of number 6 was -45875, less than old_probs, so nothing was changed.

## Probability of number 7
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/2fcde3b0-e413-4072-9a9c-c57be9a4388c)

The probability of number 7 was -100205, less than old_probs, so nothing was changed.

## Probability of number 8
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/63d8b8d1-f8fb-439e-a193-21e846766da1)

The probability of number 8 was -45871, less than old_probs, so nothing was changed.

## Probability of number 9
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/b50e2527-e65d-4668-b622-d9b04d8c575c)

The probability of number 9 was -66536, less than old_probs, so nothing was changed. Besides, the simulation time for one prediction was not its actual running time because it did not need to consider timing constraints. At last, the prediction was 5 and NN_DONE was set high.

The Python code of the neural network algorithm and its speed test are as follows:
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/9262ab17-d9a3-4433-ac1a-f515891933f2)
![image](https://github.com/ChengjunXi/FPGA-Accelerated_CNN/assets/93487110/414b2b29-c236-4178-90c9-2ed3d0843d18)

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
We have realized a hardware acceleration of convolutional neural network algorithm on number recognition. It is 95.7 times faster than the software operations. Our design was focused on saving area due to initial overflow of resources in Quartus, but it was still significantly faster than the software. Therefore, it is both area-concerned and fast. It has great potential to be further accelerated by trading area. Besides, this neural network model can be used as a submodule. It is capable of being integrated into more sophisticated designs. We have gained useful experience in accelerating neural network models.
