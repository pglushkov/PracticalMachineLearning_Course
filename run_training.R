run_training <- function() {

	source('run_total_logreg.R')

	dataFileName = 'pml-training.csv';
	splitRatio = 0.6;

	LOGREG_RES = run_total_logreg(dataFileName, splitRatio);

	TRAIN = LOGREG_RES[[1]];
	TEST = LOGREG_RES[[2]];

	library(caret)
  # LM_FIT <- train(classe ~ total_accel_belt + total_accel_arm + total_accel_forearm + accel_arm_x + accel_arm_z + roll_arm + pitch_arm + yaw_arm + gyros_arm_x + gyros_arm_y + gyros_arm_z + magnet_arm_x + magnet_arm_y + magnet_arm_z + roll_belt + pitch_belt + yaw_belt +	gyros_belt_x + gyros_belt_y + gyros_belt_z + magnet_belt_x + magnet_belt_y + magnet_belt_z + accel_dumbbell_x + accel_dumbbell_y + accel_dumbbell_z + roll_dumbbell + pitch_dumbbell + yaw_dumbbell + magnet_dumbbell_x + magnet_dumbbell_y + magnet_dumbbell_z + accel_forearm_x + roll_forearm + pitch_forearm + yaw_forearm + magnet_forearm_x + magnet_forearm_y, data = trainSet, method = 'rf');
  #	LM_FIT <- train(classe ~ total_accel_belt + total_accel_arm + total_accel_forearm + accel_arm_x + accel_arm_z + roll_arm + pitch_arm + yaw_arm + gyros_arm_x + gyros_arm_y + gyros_arm_z + magnet_arm_x + magnet_arm_y + magnet_arm_z + roll_belt + pitch_belt + yaw_belt +	gyros_belt_x + gyros_belt_y + gyros_belt_z + magnet_belt_x + magnet_belt_y + magnet_belt_z + accel_dumbbell_x + accel_dumbbell_y + accel_dumbbell_z + roll_dumbbell + pitch_dumbbell + yaw_dumbbell + magnet_dumbbell_x + magnet_dumbbell_y + magnet_dumbbell_z + accel_forearm_x + roll_forearm + pitch_forearm + yaw_forearm + magnet_forearm_x + magnet_forearm_y, data = trainSet, method = 'gbm');

	message('Starting training RF model ...');

	t1 = Sys.time();
	RF_MODEL = train(classe ~ . , data = TRAIN, method = 'rf');
	t2 = Sys.time();
	elapsed = t2-t1;
	print( sprintf('RF model training time : %f sec', elapsed ) );

	predictions = predict(RF_MODEL, TEST);
	accuracy = sum(predictions == TEST$classe) / length(predictions);

	print( sprintf("Random forest model accuracy = %f", accuracy) );

	return (list(TRAIN, TEST, RF_MODEL));
}
