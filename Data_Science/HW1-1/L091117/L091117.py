import re
import sys
import time
import requests

from bs4 import BeautifulSoup

time_interval = 0.1

class Crawler():
    def __init__(self):
        self.index = 2740
        self.image_url = []

        self.payload = {
            'from':'/bbs/Beauty/index2749.html',
            'yes': 'yes'
        }

        self.rs = requests.session()
        self.res = self.rs.post("https://www.ptt.cc/ask/over18", data=self.payload)


    def crawl(self):
        f_all = open('all_articles.txt', 'w', encoding='utf-8')
        f_popular = open('all_popular.txt', 'w', encoding='utf-8')
        
        while self.index <= 3143:
            self.url = 'https://www.ptt.cc/bbs/Beauty/index' + str(self.index) + '.html'
            self.res = self.rs.get(self.url)
            self.content = self.res.text
            self.soup = BeautifulSoup(self.content, 'html.parser')

            print('Fetch informations from : [' + self.url + ']')

            alldivs = self.soup.find_all('div', class_='r-ent')
            
            for div in alldivs:
                try:
                    date = div.select_one('.date').getText().replace('/', '').replace(' ', '')
                    title = div.select_one('a').getText()
                    url = 'https://www.ptt.cc/' + div.select_one('a').get('href')
                    nrec = div.select_one('.nrec').getText()

                    if '[公告]' in title:
                        continue
                    if self.index <= 2749 and int(date) > 201:
                        continue
                    if self.index >= 3000 and date == '101':
                        break

                    line = date + ',' + title + ',' + url + '\n'
                    f_all.write(line)

                    if nrec == '爆':
                        f_popular.write(line)
                except:
                    continue

            self.index = self.index + 1
            time.sleep(time_interval)

        f_all.close()
        f_popular.close()

    
    def push(self, start_date, end_date):
        like = 0
        boo = 0
        like_dict = {}
        boo_dict = {}

        filename = 'push[{}-{}].txt'.format(start_date, end_date)
        f = open(filename, 'w', encoding='utf-8')

        with open('all_articles.txt', 'r', encoding='utf-8') as file:
            for line in file:
                line_list = line.split(',')
                
                if int(line_list[0]) > int(end_date):
                    break
                elif int(line_list[0]) >= int(start_date) and int(line_list[0]) <= int(end_date):
                    for item in line_list:
                        if 'http' in item:
                            self.url = item.replace('\n', '')
                    self.res = self.rs.get(self.url)
                    self.content = self.res.text
                    self.soup = BeautifulSoup(self.content, 'html.parser')

                    print('Fetch informations from : [' + self.url + ']')

                    alldivs = self.soup.find_all('div', class_='push')
                    
                    for div in alldivs:
                        try:
                            push_tag = div.select_one('.push-tag').getText()
                            push_userid = div.select_one('.push-userid').getText()
                        except:
                            continue

                        if '推' in push_tag:
                            if push_userid not in like_dict:
                                like_dict[push_userid] = 0
                            like_dict[push_userid] = like_dict[push_userid] + 1
                            like = like + 1
                        elif '噓' in push_tag:
                            if push_userid not in boo_dict:
                                boo_dict[push_userid] = 0
                            boo_dict[push_userid] = boo_dict[push_userid] + 1
                            boo = boo + 1

                    time.sleep(time_interval)

            file.close()
        
        like_sort = [v[0] for v in sorted(like_dict.items(), key=lambda kv: (-kv[1], kv[0]))]
        boo_sort = [v[0] for v in sorted(boo_dict.items(), key=lambda kv: (-kv[1], kv[0]))]
        
        f.write('all like: {}\n'.format(str(like)))
        f.write('all boo: {}\n'.format(str(boo)))
        for i in range(1, 11):
            f.write('like #{}: {} {}\n'.format(i, like_sort[i], like_dict[like_sort[i]]))
        for i in range(1, 11):
            f.write('boo #{}: {} {}\n'.format(i, boo_sort[i], boo_dict[boo_sort[i]]))
        
        f.close()


    def popular(self, start_date, end_date):
        count = 0

        filename = 'popular[{}-{}].txt'.format(start_date, end_date)
        f = open(filename, 'w', encoding='utf-8')

        with open('all_popular.txt', 'r', encoding='utf-8') as file:
            for line in file:
                line_list = line.split(',')

                if int(line_list[0]) > int(end_date):
                    break
                if int(line_list[0]) >= int(start_date) and int(line_list[0]) <= int(end_date):
                    for item in line_list:
                        if 'http' in item:
                            self.url = item.replace('\n', '')
                    self.GetImage(self.url)

                    print('Fetch informations from : [' + self.url + ']')
                    count = count + 1

                    time.sleep(time_interval)

            f.write('number of popular articles: {}\n'.format(str(count)))
            for url in self.image_url:
                f.write(url + '\n')
            
            file.close()
            f.close()
        

    def keyword(self, token, start_date, end_date):
        filename = 'keyword({})[{}-{}].txt'.format(token, start_date, end_date)
        f = open(filename, 'w', encoding='utf-8')

        with open('all_articles.txt', 'r', encoding='utf-8') as file:
            for line in file:
                content = ''
                line_list = line.split(',')
                
                if int(line_list[0]) > int(end_date):
                    break
                if int(line_list[0]) >= int(start_date) and int(line_list[0]) <= int(end_date):
                    for item in line_list:
                        if 'http' in item:
                            self.url = item.replace('\n', '')
                    self.res = self.rs.get(self.url)
                    self.content = self.res.text
                    self.soup = BeautifulSoup(self.content, 'html.parser')

                    print('Fetch informations from : [' + self.url + ']')

                    alldivs = self.soup.find_all('div', class_='bbs-content')

                    for div in alldivs:
                        content = content + div.text
                
                    if content.find('--\n※ 發信站:') == -1:
                        continue
                    
                    content = content[37:content.find('--\n※ 發信站:')-1]

                    if token in content:
                        self.GetImage(self.url)
                    
                time.sleep(time_interval)
            
            for url in self.image_url:
                f.write(url + '\n')

            file.close()
            f.close()


    def GetImage(self, url):
        self.res = self.rs.get(url)
        self.content = self.res.text
        self.soup = BeautifulSoup(self.content, 'html.parser')

        alla = self.soup.find_all('a', {'target':'_blank'})
        
        for a in alla:
            if 'jpg' in a['href'] or 'jpeg' in a['href'] or 'png' in a['href'] or 'gif' in a['href']:
                self.image_url.append(a['href'])
            elif 'imgur' in a['href']:
                self.image_url.append(a['href'][:8] + 'i.' + a['href'][8:] + '.jpg')


if __name__ == '__main__':
    start = time.time()

    crawler = Crawler()

    if len(sys.argv) == 1:
        print('[ERROR] Lack of parameter.')

    elif sys.argv[1] == 'crawl':
        crawler.crawl()
    
    elif sys.argv[1] == 'push':
        if len(sys.argv) < 4:
            print('[ERROR] Lack of parameter.')
        else:
            crawler.push(sys.argv[2], sys.argv[3])
    
    elif sys.argv[1] == 'popular':
        if len(sys.argv) < 4:
            print('[ERROR] Lack of parameter.')
        else:
            crawler.popular(sys.argv[2], sys.argv[3])
    
    elif sys.argv[1] == 'keyword':
        if len(sys.argv) < 5:
            print('[ERROR] Lack of parameter.')
        else:
            crawler.keyword(sys.argv[2], sys.argv[3], sys.argv[4])
    
    else:
        print('[ERROR] Make sure the name of parameter is corrct.')
    
    end = time.time()
    print('Totally spend {:.0f} seconds.'.format(end-start))
