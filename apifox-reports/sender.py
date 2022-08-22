import requests
import os

def read():
    '''
    读取apifox-reports生成的报告
    '''
    g = os.walk(r"/workspace/devops/apifox-reports")  

    for path,dir_list,file_list in g:  
        for file_name in file_list:  
            print(file_name)
            print(os.path.join(path, file_name) )


def sender():
    pass


read()