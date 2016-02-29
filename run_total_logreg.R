run_total_logreg <- function(dataFileName, splitNum) {

	source('read_and_clean_data.R');
	DATA = read_and_clean_data(dataFileName);

	set.seed(123);
	library(caret)
	inTrain <- createDataPartition(y=DATA$classe, p = splitNum, list = FALSE);
	trainSet <- DATA[inTrain, ];
	validSet <- DATA[-inTrain, ];

	CLASSES = levels(DATA$classe);

	MODELS = list();
	PREDS = list();
	TRAINS = list();

	ACCURS = rep(0, length(CLASSES));

	# training the models and validating them
	m = 1;
	for (class in CLASSES) {
		tmpTrain = trainSet;
		tmpTrain$classe = as.integer(tmpTrain$classe == class);

		tmpValid = validSet;
		tmpValid$classe = as.integer(tmpValid$classe == class);

		# MODELS[[m]] = glm(classe ~ total_accel_belt + total_accel_arm + total_accel_forearm + accel_arm_x + accel_arm_z + roll_arm + pitch_arm + yaw_arm + gyros_arm_x + gyros_arm_y + gyros_arm_z + magnet_arm_x + magnet_arm_y + magnet_arm_z + roll_belt + pitch_belt + yaw_belt +	gyros_belt_x + gyros_belt_y + gyros_belt_z + magnet_belt_x + magnet_belt_y + magnet_belt_z + accel_dumbbell_x + accel_dumbbell_y + accel_dumbbell_z + roll_dumbbell + pitch_dumbbell + yaw_dumbbell + magnet_dumbbell_x + magnet_dumbbell_y + magnet_dumbbell_z + accel_forearm_x + roll_forearm + pitch_forearm + yaw_forearm + magnet_forearm_x + magnet_forearm_y, data = tmpTrain, family = 'binomial');
		MODELS[[m]] = glm(classe ~ ., data = tmpTrain, family = 'binomial');

		PREDS[[m]] = predict(MODELS[[m]], tmpValid, type = 'response');
		TRAINS[[m]] = predict(MODELS[[m]], tmpTrain, type = 'response');

		tmpPred = as.integer(PREDS[[m]] > 0.5);
		ACCURS[m] = sum(tmpPred  == tmpValid$classe) / length(PREDS[[m]]);
		print( sprintf("***  Accuracy of binary classifier for class %s : %f ", class, ACCURS[m]) );

		m = m + 1;
	}

	# calculating total predictions accuracy in 'one vs all' classification
	FINAL = rep(0, length(PREDS[[1]]) );
	for (pred_idx in 1:length(PREDS[[1]]) ) {

		# ugly thing, fixit ...
		tmp_preds = c( PREDS[[1]][pred_idx] , PREDS[[2]][pred_idx], PREDS[[3]][pred_idx], PREDS[[4]][pred_idx], PREDS[[5]][pred_idx]);

		max_idx = which.max(tmp_preds);
		FINAL[pred_idx] = CLASSES[max_idx];
	}

	# print(FINAL);

	precision = sum(FINAL == validSet$classe) / length(FINAL);

	print(sprintf("(ONE vs ALL) final model accuracy : %f ...", precision));

	# print(summary(trainSet$classe))

	# ugly thing, fixit ...
	stackTrain = data.frame( m1=TRAINS[[1]], m2=TRAINS[[2]], m3=TRAINS[[3]], m4=TRAINS[[4]],
		m5=TRAINS[[5]], classe=as.factor(trainSet$classe));
	stackValid = data.frame( m1=PREDS[[1]], m2=PREDS[[2]], m3=PREDS[[3]], m4=PREDS[[4]],
			m5=PREDS[[5]], classe=as.factor(validSet$classe));

	return(list(stackTrain, stackValid, MODELS));
}
