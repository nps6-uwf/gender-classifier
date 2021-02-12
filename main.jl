# classifying men and women with the knearest neighbors algorithm
# nick sebasco

k = 3
file = "weight-height.csv"
dist(u1,u2) = sqrt(sum((u1.-u2).^2))


test, train, kneighbors = [], [], [[Inf,[]] for i in 1:k]
votes = Dict{String,Integer}()

# 1) split data into training  and testing arrays
io = open("weight-height.csv","r")
for line in eachline(io)
  s = split(line, ",")
  gender, height, weight = s
  push!(rand(1:100) < 10 ? test : train,[gender,parse(Float64,height),parse(Float64,weight)])
end

# 2) Manually supply a test vector to classify or randomly choose one from test
test_vector = test[rand(1:length(test))]
println("height: ",test_vector[2])
println("weight: ",test_vector[3])
println("What is the gender of this person?")


# 3) calculate the nearest neighbors
for train_vector in train
  d = dist(train_vector[2:length(train_vector)], test_vector[2:length(test_vector)])
  for i in 1:length(kneighbors)
    kd,kv = kneighbors[i]
    if abs(d) < abs(kd)
      kneighbors[i] = [d,train_vector]
      break
    end
  end
end

# 4) have the nearest neighbors vote on which class they think the test_vector belongs
for neighbor in map((k)-> k[2][1],kneighbors)
  votes[neighbor] = haskey(votes,neighbor) ? votes[neighbor] + 1 : 1
end

println("KNN predicted gender: ",maximum(votes)[1])
println("Actual gender: ",test_vector[1])