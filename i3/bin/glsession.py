#!/usr/bin/env python3

import argparse
import os

# Third Party Libraries
import requests
from gitlab import Gitlab
from subprocess import call

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    def pgreen(t):
        print(OKGREEN + t + ENDC)


if __name__ == '__main__':
    gl = Gitlab.from_config(None, [os.path.expanduser("~/.gitlab.cfg")])
    parser = argparse.ArgumentParser()
    parser.add_argument("action")
    args = parser.parse_args()

    if args.action == "nestor":
        p = gl.projects.get('swlabs/nestor/core/gitlab-celery')
        pp = p.pipelines.list(ref="master", simple=True)[0]
        state = pp.status
        url = pp.web_url
        if os.getenv('BLOCK_BUTTON'):
            call(['browse', url])
        if state == "success":
            color="green"
        elif state == "running":
            color="orange"
        else:
            color="red"
    else:

        if os.getenv('BLOCK_BUTTON'):
            if args.action == "todo":
                call('browse https://gitlabee.dt.renault.com/dashboard/todos'.split(' '))
            elif args.action == "issues":
                call('browse https://gitlabee.dt.renault.com/dashboard/issues?assignee_id=248'.split(' '))
            elif args.action == "mrs":
                call('browse https://gitlabee.dt.renault.com/dashboard/merge_requests?assignee_id=248'.split(' '))

        if args.action == "todo":
            state = 0
            for todo in gl.todos.list(simple=True):
                if todo.target['state'] not in ('merged','closed'):
                    state += 1
        elif args.action == "issues":
            state = len(gl.issues.list(scope='assigned-to-me',state='opened', simple=True))
        elif args.action == "mrs":
            state = len(gl.mergerequests.list(scope='assigned-to-me',state='opened'))

        if state == 0:
            color="green"
        elif state < 5:
            color="orange"
        else:
            color="red"

    print('<span foreground="' + color + '">' + str(state) + '</span>')
        # print('<span foreground="green"><i>' + str(len(GL().gl.todos.list(simple=True))) + '</i>]</span><sup>+1</sup>')
        # print(len(GL().gl.todos.list(simple=True)))
        # print('<span foreground="green">' + len(GL().gl.todos.list(simple=True)) + '</span>')
