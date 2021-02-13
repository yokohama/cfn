import os
import sys
import subprocess
import glob
import json
import re

#PJ_HOLDER_PATH = '/Users/yokohama/projects/svc/cfn'
PJ_HOLDER_PATH = './'
PARAMS_FILE = PJ_HOLDER_PATH + '/params.cnf'

CFN_CMD_TMP = 'aws cloudformation delete-stack --stack-name {} 1>/dev/null'
CFN_GET_OUTPUT_TMP = 'aws cloudformation wait stack-create-complete --stack-name {} && aws cloudformation describe-stacks --output json --stack-name {}'

PARAMETERS = []


def main():
    if (len(sys.argv) != 3) and (len(sys.argv) != 4):
        usage()
        return

    project_name = sys.argv[2]

    if sys.argv[1] == '-d':
        delete_stacks(project_name)
    elif (sys.argv[1] == '-c') and (len(sys.argv) == 4):
        create_stacks(project_name, sys.argv[3])
    else:
        usage()


def usage():
    print('Usage:]')
    print('[Create]  : python cfn.py -c [projectName] [domain]')
    print('[Delete]  : python cfn.py -d [projectName]')
    print('ex) python cfn.py -c Hoge hoge.com')
    return


def delete_stacks(project_name):
    delete_shell_list = shell_list()
    delete_shell_list.reverse()

    for shell in delete_shell_list:
        step_name = re.sub(r'\.sh$', '', shell)
        stack_name = '{}-{}'.format(project_name, step_name)
        subprocess.call(CFN_CMD_TMP.format(stack_name), shell=True)


def create_stacks(project_name, domain):
    for line in open(PARAMS_FILE, 'r'):
        PARAMETERS.append(line.rstrip('\n'))

    params_update('HostZone', domain)
    print_params()

    for shell in shell_list():
        step_name = re.sub(r'\.sh$', '', shell)
        stack_name = '{}-{}'.format(project_name, step_name)

        print('-> Createing {} Stack. please wait.'.format(stack_name))

        subprocess.call([
            '{}/{}'.format(PJ_HOLDER_PATH, shell),
            re.sub(r'\.sh$', '', stack_name),
        ])
        set_params(stack_name)


def shell_list():
    shell_list = []
    for file_path in glob.glob('{}/*.sh'.format(PJ_HOLDER_PATH)):
        file = os.path.split(file_path)[1]
        if re.match('^\d*-.*', file):
            shell_list.append(file)

    return sorted(shell_list)


def set_params(stack_name):
    cmd = CFN_GET_OUTPUT_TMP.format(stack_name, stack_name)
    res = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    json_res = json.loads(res.communicate()[0].decode())
    if 'Outputs' in json_res['Stacks'][0]:
        json_outputs = json_res['Stacks'][0]['Outputs']
        for json_output in json_outputs:
            params_update(json_output['OutputKey'], json_output['OutputValue'])

    print_params()


def params_update(key, val):
    is_new = True
    for index, param in enumerate(PARAMETERS):
        param_key = param.split('=')[0]

        if key == param_key:
            PARAMETERS[index] = '{}={}'.format(key, val)
            is_new = False
    
    if is_new:
        PARAMETERS.append('{}={}'.format(key, val))

    with open(PARAMS_FILE, 'w') as f:
        for param in PARAMETERS:
            f.write('{}\n'.format(param))


def print_params():
    print('== parameters ===========')
    for param in PARAMETERS:
        print(param)
    print('=========================')


main()
