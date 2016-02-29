run_analysis <- function() {

	source('read_and_clean_data.R');
	DATA = read_and_clean_data('pml-training.csv');

	# print(DATA);
	# str(DATA)
	# print(names(DATA));
	# print(nrow(DATA));
	# print(ncol(DATA));

	# print(names(DATA));
	print(summary(DATA))

	# pairs(~ pitch_belt + roll_belt + yaw_belt, data = DATA);
	scatterplotMatrix(~ pitch_belt + roll_belt + yaw_belt|classe, data=DATA,  main="Le exercise",
			smoother="", reg.line="")


	print("Plotting 1");
	png('./all_total_accel.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ total_accel_belt + total_accel_arm + total_accel_dumbbell + total_accel_forearm|classe,
				data=DATA, main="Le exercise", smoother="", reg.line="");
	dev.off();

	print("Plotting 2");
	png('./belt_angles.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ pitch_belt + roll_belt + yaw_belt|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 3");
	png('./belt_gyros.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ gyros_belt_x + gyros_belt_y + gyros_belt_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 4");
	png('./belt_accel.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ accel_belt_x + accel_belt_y + accel_belt_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 5");
	png('./belt_magnet.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ magnet_belt_x + magnet_belt_y + magnet_belt_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 6");
	png('./arm_angles.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ roll_arm + pitch_arm + yaw_arm|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 7");
	png('./arm_gyros.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ gyros_arm_x + gyros_arm_y + gyros_arm_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 8");
	png('./arm_accel.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ accel_arm_x + accel_arm_y + accel_arm_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 9");
	png('./arm_magnet.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ magnet_arm_x + magnet_arm_y + magnet_arm_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 10");
	png('./dumbbell_angles.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ roll_dumbbell + pitch_dumbbell + yaw_dumbbell|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 11");
	png('./dumbbell_gyros.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ gyros_dumbbell_x + gyros_dumbbell_y + gyros_dumbbell_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 12");
	png('./dumbbell_accel.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ accel_dumbbell_x + accel_dumbbell_y + accel_dumbbell_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 13");
	png('./dumbbell_magnet.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ magnet_dumbbell_x + magnet_dumbbell_y + magnet_dumbbell_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 14");
	png('./forearm_angles.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ roll_forearm + pitch_forearm + yaw_forearm|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 15");
	png('./forearm_gyros.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ gyros_forearm_x + gyros_forearm_y + gyros_forearm_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 16");
	png('./forearm_accel.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ accel_forearm_x + accel_forearm_y + accel_forearm_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();

	print("Plotting 17");
	png('./forearm_magnet.png', width = 3.25, height = 3.25, units = "in", res = 1200, pointsize = 4);
	scatterplotMatrix(~ magnet_forearm_x + magnet_forearm_y + magnet_forearm_z|classe, data=DATA,  main="Le exercise",
				smoother="", reg.line="")
	dev.off();
}
