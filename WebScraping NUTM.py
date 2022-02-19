# import urllib.request, urllib.parse, urllib.error
# from bs4 import BeautifulSoup
# from bs4.element import Comment
# import re

# url = 'http://py4e-data.dr-chuck.net/known_by_Fikret.html'
# html = urllib.request.urlopen(url).read()
# soup = BeautifulSoup(html, 'lxml')

# links = soup('li')
# linklist =[]
# count = 0
# for link in links:
#     jan = link.find('a', href=True)
#     linklist.append(jan['href'])
#     # if count == 3:
#     # person = link    
#     # count += 1
'''
def find3rd(links):
    linklist =[]
    for link in links:
        march = link.find('a', href=True) 
        linklist.append(march)
    
    print(linklist[17].text)
    print(linklist[17]['href'])
    return linklist[17]['href']

count = 0

def findLink(url):
    global count
    html = urllib.request.urlopen(url).read()
    soup = BeautifulSoup(html, 'lxml')   
    links = soup('li')
    link3 = find3rd(links)
    count +=1	
    if count < 7:
        findLink(link3)

# for i in range(1,4):
findLink('http://py4e-data.dr-chuck.net/known_by_Adonica.html')



# NUTM Funding ......................

from urllib.request import Request, urlopen
from bs4 import BeautifulSoup
from bs4.element import Comment

def NutmFunding (url):
    req = Request(url , headers={'User-Agent': 'Mozilla/5.0'})
    webpage = urlopen(req).read()
    soup = BeautifulSoup(webpage, 'html.parser')   
    fundings = soup('article')
    # print(fundings)
    for funding in fundings:
        fundingText = funding.find('p')
        if  'africa' in funding.getText().lower():
            fundName = funding.find('h2', class_ = 'entry-title')
            fundingText = funding.find('p')
            readMore = funding.find('a', class_='more-link')
            print(fundName.text, '\n', fundingText.text, '\n',readMore['href'])
            print('-----------------------------------')


    endPage = soup.find_all('a') 
    for i in endPage:
        if i.text == 'Next Page »':
            newUrl = i['href']
            NutmFunding(newUrl)

NutmFunding('https://www2.fundsforngos.org/category/latest-funds-for-ngos/page/3/')


'''

# NUTM Funding2222 ......................

from urllib.request import Request, urlopen
from bs4 import BeautifulSoup
from bs4.element import Comment
import csv

header = ['Name', 'link', 'content']

data = []

def moreDetails(url):
    req = Request(url , headers={'User-Agent': 'Mozilla/5.0'})
    webpage = urlopen(req).read()
    soup = BeautifulSoup(webpage, 'html.parser') 

    details = soup.find_all('p' )
    details =details[0]
    details = details.find('p')
    empArr = []
    for i in details:
        empArr.append(i.text)
    
    narr = empArr[1].split('»')
    level2 = narr[0].strip()
    level3 = ''.join(level2)
    return level3.replace('\n', '')




def NutmFunding (url):
    req = Request(url , headers={'User-Agent': 'Mozilla/5.0'})
    webpage = urlopen(req).read()
    # time.sleep(5)
    soup = BeautifulSoup(webpage, 'html.parser')   
    container = soup('div', class_='Liner')
    # print(len(container))
    fundings = container[1].find_all('a')
    # print(len(fundings))
    for funding in fundings:
        # fundingLink = funding.find('a')
        fundingHead = funding.find('li')
        if fundingHead != None:
            fundList = fundingHead.getText()
            if 'education' in fundList.lower():
                content = moreDetails(funding['href'])
                data.append([fundList,  funding['href'], content])
                # print(fundList, funding['href'], content)
                    # print('---------------------')


            # if  'nigeria' in fundingHead.text.lower():
            #     fundName = fundingHead.getText()
            #     print(fundingHead)

    # for funding in fundings:
    #     fundingLink = funding.a['href']
    #     print (fundingLink)

NutmFunding('https://www.advance-africa.com/Grants-for-NGOs-and-Organisations.html')

# print(data)

with open('Funding7education.csv', 'w', encoding='UTF8') as csvfile:
    writer = csv.writer(csvfile, delimiter=',')
    writer.writerow(header)
    for i in data:
        writer.writerow(i)


print('done')

print(len(data))
