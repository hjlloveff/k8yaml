# encoding: utf-8
import commands
import os
import linecache
import json
#--------------------------------------------------------------------
newsrc="tranyaml"
neednodeselector="no"
needpushregistry=True
# "yes" or "no"
tag="201712211230"
newrepo="registry.cs/ailab/"
targetDir="./tranimages/"
harborurl="172.16.101.70"

#--------------------------------------------------------------------
def pull_old_image(inputimage):
   funcommand="docker pull "+inputimage
   print funcommand
   res=commands.getoutput(funcommand)
   return

def tag_image(oldimagename,newimagename):
   funcommand="docker tag "+oldimagename+" "+newimagename
   print funcommand
   res=commands.getoutput(funcommand)
   return

def save_image(imagename,path,tarname):
   funcommand="docker save "+imagename+" > "+path+tarname+".tar"
   print funcommand
   res=commands.getoutput(funcommand)
   return
def harbor_login(harbor):
   funcommand="docker login "+harbor+" -u admin -p Emotibot1"
   print funcommand
   res=commands.getoutput(funcommand)
   return
def push_image(imagename):
   funcommand="docker push "+imagename
   print funcommand
   res=commands.getoutput(funcommand)
   return

if needpushregistry==True:
   harbor_login(harborurl)

res=commands.getoutput("rm %s -rf"%newsrc)
res=commands.getoutput("cp source %s -rf"%newsrc)
res=commands.getoutput("mkdir -p %s"%targetDir)
datas=commands.getoutput("grep -Rn \"containers:\" %s/"%newsrc)
# 用grep 找出指定目錄下的所有nodeSelector
data=datas.split("\n")
#找到的結果用換行字元分出來
multijson=[]
print type(multijson)
for con in data:
   jsoncontent={}
   print type(jsoncontent)
   content=con.split(":")
   filepath=content[0]
   jsoncontent['source-file']=filepath
   print "%s"%filepath
   second=content[1]
#   print "%s"%second
   module=""
   f = open("%s"%filepath)             # 返回一个文件对象
   line = f.readline()
   count=1
   nodeline=0
   filecontent=['']
   filecontent.append(line)
   labeltoken=False
# 调用文件的 readline()方法
   while line:
      count=count+1
      modifytoken=False
#      labeltoken=False
      line = f.readline()
#      print line
#      filecontent.append(line)
      if not line.find("image:")==-1 and line.find("#")==-1:
         spline=line.split("/")
#         print "0 : "+spline[0]
#         print "1 : "+spline[1]
#         print "2 : "+spline[2]
         part1line=spline[0].split(":")
         part3line=spline[2].split(":")
         module=part3line[0]
         jsoncontent['module-name']=module
         newline=part1line[0]+": "+newrepo+part3line[0]+":"+part3line[1].replace("\n","",1)+"-"+tag+"\n"
         print "old :%s" %line
         print "new :%s" %newline
         modifytoken=True
         oldimag=part1line[1]+"/"+spline[1]+"/"+spline[2].replace("\n","",1);
         newimag=newrepo+part3line[0]+":"+part3line[1].replace("\n","",1)+"-"+tag
         pull_old_image(oldimag)
         tag_image(oldimag,newimag)
         save_image(newimag,targetDir,part3line[0])
         if needpushregistry==True:
            push_image(newimag)
         jsoncontent['original-image name']=oldimag
         jsoncontent['new-image-name']=newimag
      if labeltoken==True:
         if neednodeselector=="no":
            print "Add # to %s in line %d" %(filepath,count)
            newline=line.replace(" ","#",1);
            jsoncontent['original-Selector-keyValue']=line
            jsoncontent['new-Selector-keyValue']=newline
         elif neednodeselector=="yes":
            print "Remove # to %s in line %d" %(filepath,count)
            newline=line.replace("#","",1);
            jsoncontent['original-Selector-keyValue']=line
            jsoncontent['new-Selector-keyValue']=newline
         modifytoken=True
         labeltoken=False
      if not line.find("nodeSelector")==-1:
#         print line
         jsoncontent['need-Node-Selector']=neednodeselector
         if neednodeselector=="no":
            if line.find("#")==-1:
               print "Add # to %s in line %d" %(filepath,count)
               newline=line.replace(" ","#",1);
               modifytoken=True;labeltoken=True
               jsoncontent['original-nodeSelector']=line
               jsoncontent['new-nodeSelector']=newline
         elif neednodeselector=="yes":
            if not line.find("#")==-1:
               print "Remove # to %s in line %d" %(filepath,count)
               newline=line.replace("#","",1);
               modifytoken=True;labeltoken=True
               jsoncontent['original-nodeSelector']=line
               jsoncontent['new-nodeSelector']=newline
      if modifytoken==True:
         filecontent.append(newline)
      elif modifytoken==False:
         filecontent.append(line)
   f.close()
   rmres=commands.getoutput("rm -rf %s"%filepath)
   f = file(filepath, "w")
   i=0
   for i in range(len(filecontent)):
#      print(filecontent[i])
      f.write(filecontent[i])
      i=i+1
   multijson.append(jsoncontent)
   encodedjson=json.dumps(multijson,indent = 4,sort_keys = True)
   print  encodedjson
