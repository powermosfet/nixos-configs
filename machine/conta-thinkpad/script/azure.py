#!/usr/bin/env python3

import requests, json, sys, re
from pathlib import Path

with open(Path.home().joinpath('.azure.json')) as settings_file:
    settings = json.load(settings_file)

workitem_id = sys.argv[1] 
if len(sys.argv) > 2:
    cmd = sys.argv[2] 
else:
    cmd = 'print'

s = requests.Session()
s.auth = ('', settings['token'])
url = 'https://dev.azure.com/{organization}/{project}/_apis/wit/workitems/{id}?api-version=7.1-preview.3'.format(
        organization=settings['organization'],project=settings['project'],id=workitem_id)
r = s.get(url)

def cmd_title(wi):
    return wi['fields']['System.Title']

def cmd_print(wi):
    return 'AZ-{}: {}'.format(wi['id'], cmd_title(wi))

def cmd_tr(wi):
    return wi['fields'].get('Custom.HarvestProjectID')

def cmd_tw(wi):
    return 'H' + cmd_tr(wi) 

def cmd_url(wi):
    return 'https://dev.azure.com/{organization}/{project}/_workitems/edit/{id}'.format(
            organization=settings['organization'],
            project=settings['project'],
            id=workitem_id
            )

def cmd_json(wi):
    return json.dumps(wi)

def cmd_branch(wi):
    title = re.sub('\\s+', '-', re.sub('[^\\w\\s]*', '', cmd_title(wi).strip().lower()))
    return 'az/{}-{}'.format(wi['id'], title)

cmd_fns = {
    'print': cmd_print,
    'title': cmd_title,
    'tr': cmd_tr,
    'tw': cmd_tw,
    'url': cmd_url,
    'json': cmd_json,
    'branch': cmd_branch
    }

def process(cmd, wi):
    fn = cmd_fns.get(cmd)
    if fn:
        print(fn(wi), end='\n' if sys.stdout.isatty() else '')
    else:
        print('Unknown command \'{}\'.'.format(cmd))

if r.status_code == 200:
    process(cmd, r.json())
    # print(json.dumps(r.json()))
else:
    print("ERROR!", r.status_code)
    print(r.text)
