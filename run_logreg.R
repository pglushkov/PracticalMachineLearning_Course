run_logreg <- function(className, splitNum) {

	source('read_and_clean_data.R');
	DATA = read_and_clean_data('pml-training.csv');

	DATA$classe = as.integer(DATA$classe ==className);

	set.seed(123);

	library(caret)

	inTrain <- createDataPartition(y=DATA$classe, p=splitNum, list = FALSE);

	trainSet <- DATA[inTrain, ];
	validSet <- DATA[-inTrain, ];

  # LM_FIT <- train(classe ~ total_accel_belt + total_accel_arm + total_accel_forearm + accel_arm_x + accel_arm_z + roll_arm + pitch_arm + yaw_arm + gyros_arm_x + gyros_arm_y + gyros_arm_z + magnet_arm_x + magnet_arm_y + magnet_arm_z + roll_belt + pitch_belt + yaw_belt +	gyros_belt_x + gyros_belt_y + gyros_belt_z + magnet_belt_x + magnet_belt_y + magnet_belt_z + accel_dumbbell_x + accel_dumbbell_y + accel_dumbbell_z + roll_dumbbell + pitch_dumbbell + yaw_dumbbell + magnet_dumbbell_x + magnet_dumbbell_y + magnet_dumbbell_z + accel_forearm_x + roll_forearm + pitch_forearm + yaw_forearm + magnet_forearm_x + magnet_forearm_y, data = trainSet, method = 'rf');
  # LM_FIT <- train(classe ~ total_accel_belt + total_accel_arm + total_accel_forearm + accel_arm_x + accel_arm_z + roll_arm + pitch_arm + yaw_arm + gyros_arm_x + gyros_arm_y + gyros_arm_z + magnet_arm_x + magnet_arm_y + magnet_arm_z + roll_belt + pitch_belt + yaw_belt +	gyros_belt_x + gyros_belt_y + gyros_belt_z + magnet_belt_x + magnet_belt_y + magnet_belt_z + accel_dumbbell_x + accel_dumbbell_y + accel_dumbbell_z + roll_dumbbell + pitch_dumbbell + yaw_dumbbell + magnet_dumbbell_x + magnet_dumbbell_y + magnet_dumbbell_z + accel_forearm_x + roll_forearm + pitch_forearm + yaw_forearm + magnet_forearm_x + magnet_forearm_y, data = trainSet, method = 'gbm');

	LOG_REG = glm(classe ~ total_accel_belt + total_accel_arm + total_accel_forearm + accel_arm_x + accel_arm_z + roll_arm + pitch_arm + yaw_arm + gyros_arm_x + gyros_arm_y + gyros_arm_z + magnet_arm_x + magnet_arm_y + magnet_arm_z + roll_belt + pitch_belt + yaw_belt +	gyros_belt_x + gyros_belt_y + gyros_belt_z + magnet_belt_x + magnet_belt_y + magnet_belt_z + accel_dumbbell_x + accel_dumbbell_y + accel_dumbbell_z + roll_dumbbell + pitch_dumbbell + yaw_dumbbell + magnet_dumbbell_x + magnet_dumbbell_y + magnet_dumbbell_z + accel_forearm_x + roll_forearm + pitch_forearm + yaw_forearm + magnet_forearm_x + magnet_forearm_y, data = trainSet, family = 'binomial');
1
	PRED = predict(LOG_REG, validSet, type = 'response');

	PRED = as.integer(PRED > 0.5);
	plot(PRED)

	precision = sum(PRED == validSet$classe) / length(PRED);

	print(sprintf("FINAL PRECISION IS : %f ...", precision));

	return (list(trainSet, validSet, LOG_REG));
}
