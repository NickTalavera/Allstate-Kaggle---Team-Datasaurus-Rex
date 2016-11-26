
submission_1 = read.csv('../Results/h2o_blend.csv')
submission_2 = read.csv('../Results/xgb_forum_baseline.csv')
submission_3 = read.csv('../Results/xgb_forum_baseline.csv')

ensemble_loss = (submission_1$loss + submission_2$loss + submission_3$loss) / 3
ids = submission_1$id

ensemble = data.frame(id = ids, loss = ensemble_loss)

write.csv(ensemble, '../Results/ensemble.csv', row.names = FALSE)
