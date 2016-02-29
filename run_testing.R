run_testing <- function() {

	source('run_total_logreg.R')
  source('read_and_clean_data.R')

	dataFileName = 'pml-training.csv';
  testDataFileName = 'pml-testing.csv'
	splitRatio = 0.6;

  TEST_DATA = read_and_clean_data(testDataFileName);
  print( summary(TEST_DATA) );

	LOGREG_RES = run_total_logreg(dataFileName, splitRatio);

  BIN_MODELS = LOGREG_RES[[3]];

  BIN_PREDS = list();
  m = 1;
  for (model in BIN_MODELS) {

    BIN_PREDS[[m]] = predict(model, TEST_DATA, type = 'response');

    m = m + 1;
  }

  stackTest = data.frame( m1=BIN_PREDS[[1]], m2=BIN_PREDS[[2]], m3=BIN_PREDS[[3]], m4=BIN_PREDS[[4]],
		m5=BIN_PREDS[[5]]);

  library(caret);
  load('rf_final_model.RData')
  TEST_RES = predict(FINAL_MODEL, stackTest);
  print(TEST_RES);

	return (TEST_RES);

}
