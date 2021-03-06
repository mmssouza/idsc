#!/usr/bin/python -u

import sys
import os.path
import getopt
import cPickle
import optimize
import oct2py
import numpy as np
import amostra_base
from functools import partial
from time import time
from pdist_mt import silhouette
import atexit

if __name__ == '__main__':
 mt = 2
 dataset = ""
 fout = ""
 dim = -1
 NS = 5 

 oc = oct2py.Oct2Py()
 oc.addpath("common_innerdist")
 atexit.register(oc.exit)
  
 try:                                
  opts,args = getopt.getopt(sys.argv[1:], "o:d:", ["mt=","dim=","output=","dataset="])
 except getopt.GetoptError:           
  print "Error getopt"                          
  sys.exit(2)          
 
 for opt,arg in opts:
  if opt == "--mt":
   setattr(sys.modules[__name__],"mt",int(arg))
  elif opt in ("-o","--output"):
   fout = arg
  elif opt in ("-d","--dataset"):
   dataset = arg
  elif opt == "--dim":
   dim = int(arg)
  
 conf = [float(i) for i in args]

 if dataset == "" or fout == "" or len(conf) != 4 or dim <= 0:
  print "Error getopt" 
  sys.exit(2)

 algo = "sa"
 has_dump_file = False
 if os.path.isfile("dump_optimize_sa.pkl"):
  has_dump_file = True
  dump_fd = open("dump_optimize_sa.pkl","r")
  nn = cPickle.load(dump_fd)
  mm = cPickle.load(dump_fd)
 else:
  nn = 0
  mm = 0  

 N,M = 200,3

 Head = {'algo':algo,'conf':"T0,alpha,P,L = {0},{1},{2},{3}".format(conf[0],conf[1],conf[2],conf[3]),'dim':dim,"dataset":dataset}
 
 Y,names = [],[]
 with open(dataset+"/"+"classes.txt","r") as f:
  cl = cPickle.load(f)
  nm = amostra_base.amostra(dataset,NS)
  for k in nm:
   Y.append(cl[k])
   names.append(dataset+"/"+k)
  
 def cost_func(args):  
  Ncpu = mt
  Nc = 100
  n_dist = args[0]
  n_theta = args[1]
  tt = time() 
  N = len(names)
  print "idsc leaves: Avaliando funcao custo para N = {0}, Nc = {1},Theta = {2}, n_dist = {3}".format(N,Nc,n_theta,n_dist) 
  #oc.eval("pkg load statistics;")
  oc.clear()
  sc,md = oc.Batch_Comp_IDSC(names,Nc,n_dist,n_theta)
  #print "Calculando Silhouette"
  cost = float(np.median(1. - silhouette(md,np.array(Y)-1,Nthreads = 2,arg ='dmat')))
  #print
  #print "tempo total: {0} seconds".format(time() - tt)
  #print "cost = {0}".format(cost)
  return cost
 
 with open(fout,"ab",0) as f:
  if not has_dump_file:
   cPickle.dump(Head,f)
   cPickle.dump((N,M),f)
  for j in range(mm,M):
   w = optimize.sim_ann(cost_func,conf[0],conf[1],conf[2],conf[3])
   for i in range(nn,N):
    w.run()
    dump_fd = open("dump_optimize_sa.pkl","wb")
    cPickle.dump(i+1,dump_fd)
    cPickle.dump(j,dump_fd)
    dump_fd.close()
    print "idsc leaves: ",i,w.s,w.fit
    cPickle.dump([i,w.fit,w.s],f)
   os.remove("dump_sim_ann.pkl") 
   cPickle.dump(w.hall_of_fame[0],f)
   nn = 0 
