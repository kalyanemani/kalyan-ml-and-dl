# kalyan-ml-and-dl
MACHINE LEARNING PROBLEMS
1. decathlon_Tokyo.csv contains the names of 19 athletes who completed the decathlon at the
Tokyo olympics, along with their results in each event. The columns represent the events in the order
they took place: 100m, long jump, shot put, high jump, 400m, 110m hurdles, discus throw, pole vault,
javelin throw and 1500m.
2. decathlon_pb.csv contains the the names of 19 athletes who completed the decathlon at the
Tokyo olympics, along with their height (cm), weight (kg), age (months) and personal best (PB)
performances in each event going into the Tokyo olympics.

Solution
performed multiple linear regression analysis on datasets to find out remaining values of athelete.

problem 2
In this question, you will use the random_search algorithm introduced in the lectures. The code is already
provided in the cell below.
(a) Write a function called himmelblau that implements the Himmelblau function:
This function should take in a numpy column vector representing and return the value of 
. [2 marks]
(b) Amend the random_search function to implement another option for alpha_choice called 
decay . In this setting, alpha should be set to , where is the natural base.
[2 marks]
(c) Perform an experiment to investigate the effect of alpha_choice when optimizing the Himmelblau
function with the following settings:
Number of steps 
Number of random directions at each step 
Initial point 
You should investigate three settings for : fixed steplength of , 'diminishing' and 'decay'.
Show the results from your experiments by plotting (on the same figure) the cost history (i.e. history of
objective function values) against iteration number for the three settings of the random search. Any
differences in the performance of the three settings should be clear from the figure. [4 marks]
(d) Comment on the worst performing setting of the random search in (c), giving an explanation of why it
does not perform as well as the other two settings. [2 marks]

solution:
1) when compared all three model settings of alpha choice=1,'diminishing','decay' the
with unsteadily for few steps and started declining steadily towards global minimum. 2)when alpha choice is 'diminishing' cost funtion descending steadily when compared wi
3)when alphachoice is '1' cost function started descending after a step further when c 4)additionally, when i performed cutting the aplha choice = '0.1' started descending a 5)alphachoice = '0.001'is far more steps than alpha choice ='0.001.

problem:
The dataset that we will use for this task will be provided and you can
downland it from the Blackboard. The dataset includes three files for three
exercises. The 1st, 5th and 9th columns (with long data like 2107727051) are
time stamps when the data were collected, while other columns contain
readings from different sensors. The classification problem is to predict the
type of exercise. In this task, you are required to use k fold cross-validation.

[Data preparation]: You shall prepare the data for clustering. [2 marks]
2. [K-means clustering]: apply the K-means clustering algorithm to analyse
the data. You shall:
a. tune the parameter setting, select the optimal cluster number using
the elbow method [2 marks]
b. use clustering validity indices to confirm the selection of K value
[3 marks]
c. visualise the centroids and the clustering results. [3 marks]
3. [hierarchical clustering]: apply the hierarchical clustering algorithm to
analyse the data. You shall (1) tune the parameters, (2) visualise
clustering results, and (3) calculate clustering validity indices, and also
display the results.
[6 marks]
4. [Evaluation] Evaluate the performance of these two clustering methods
by comparing the clustering results with the known exercise type 
