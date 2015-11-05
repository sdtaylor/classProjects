


logisticLiklehood=function(guess, x,y){
  a=guess[1]
  b=guess[2]
  
  likeloodFunction=function(xi,yi) { ((1/(1+exp(-1*(a+b*xi))))**yi) * ((1/(1+exp(-1*(a+b*xi))))**(1-yi))}
  
  liklehood=prod( unlist(mapply(data, x,  y)))

}