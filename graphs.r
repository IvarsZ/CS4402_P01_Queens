queries <- read.table("results.txt", head = TRUE, sep=" ", fill=TRUE)

p <- 0
zero <-c(0)
p_range <-c('p1', 'p2', 'p4')
c_range <-c(1, 2, 3)

q <- aggregate(queries[c("i", "time", "nodes", "queens")], by=queries[c("part", "m")], FUN=mean)
q$time <- round(q$time, 3)

cilLow <- function(x) {
  result <- t.test(x, conf.level = 0.95)$conf.int[1]
  return (result)
}

q.cilLow <- aggregate(queries[c("time")], by=queries[c("part", "m")], FUN=cilLow)
q$cilLow = round(q.cilLow$time, 4)

q.sd <- aggregate(queries[c("time")], by=queries[c("part", "m")], FUN=sd)
q$sd = round(q.cilLow$time, 3)

q$absError <- q$time - q$cilLow
q$relError <- round(q$absError / q$time, 1) * 100

q$cilUp <- q$time + q$absError

plot(zero, zero, xlab="m", ylab="Time, s", log="y", main="Solving time for different parts", pch=p, xlim=c(0, 13), ylim=c(0.001, 200), yaxt="n")
for (c in c_range) {
  p_set <- subset(q, q$part == p_range[c])
  lines(p_set$m, p_set$time, col=c)
  points(p_set$m, p_set$time, col=c)
}
legend("topleft", title="parts", legend=p_range, col=c_range, cex=0.5, pch=1)
aty <- axTicks(2)
labels <- sapply(aty,function(i)
  as.expression(bquote(.(i)))
)
axis(2,at=aty,labels=labels)

plot(zero, zero, xlab="m", ylab="Nodes, no.", log="y", main="Nodes", pch=p, xlim=c(0, 13), ylim=c(1, 100000000), yaxt="n")
for (c in c_range) {
  p_set <- subset(q, q$part == p_range[c])
  lines(p_set$m, p_set$nodes, col=c)
  points(p_set$m, p_set$nodes, col=c)
}
legend("topleft", title="parts", legend=p_range, col=c_range, cex=0.5, pch=1)
aty <- axTicks(2)
labels <- sapply(aty,function(i)
  as.expression(bquote(.(i)))
)
axis(2,at=aty,labels=labels)

plot(zero, zero, xlab="m", ylab="queens, no.", main="Number of queens", pch=p, xlim=c(0, 12), ylim=c(0, 7))
p_set <- subset(q, q$part == "p1")
lines(p_set$m, p_set$queens)
points(p_set$m, p_set$queens)
