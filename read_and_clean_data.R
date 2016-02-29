read_and_clean_data <- function(file_name) {

  DATA = read.csv(file_name);

  VARS = names(DATA);
  # print(VARS)

  FINAL_VARS = vector();
  num_na = vector();
  for (var_name in VARS) {

    tmp = sum( is.na(DATA[[var_name]]) );

    num_na = cbind(num_na, tmp);
    if (tmp == 0) {
      FINAL_VARS = cbind(FINAL_VARS, var_name);
    }
  }

  colnames(FINAL_VARS) <- rep("", length(FINAL_VARS));
  FINAL_VARS = filter_names(FINAL_VARS);

  OUTCOME = 'classe';

  # print(FINAL_VARS);
  # print(length(FINAL_VARS));
  # print(num_na);

  # out_data = as.character(DATA[ , c(OUTCOME)]);
  # out_data = DATA$classe;

  out_data = DATA[ , c(FINAL_VARS) ];

  leave_idx = vector();
  for (k in 1:ncol(out_data)) {
    if (!is.factor(out_data[ , k])) {
      leave_idx = cbind(leave_idx, k);
    }
  }

  # print(leave_idx)

  out_data = out_data[ , leave_idx];

  # adding 'outcome' variable into the le dataset
  if ( is.null(DATA[[OUTCOME]]) ) {
    # do nothing ...
  } else {
    out_data = cbind( classe=DATA[, c(OUTCOME)], out_data );
  }

  return(out_data);
}

filter_names <-function(in_names) {
  n1 = grepl('belt', in_names);
  n2 = grepl('arm', in_names);
  n3 = grepl('dumbbell', in_names);
  n4 = grepl('forearm', in_names);

  out_names = in_names[n1 | n2 | n3 | n4];
  return(out_names);
}
