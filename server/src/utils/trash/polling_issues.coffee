http = require 'http'
fs = require 'fs'
path = require 'path'
utils = require '../utils/utils'
request = require('request');
log = require('winston-color')
log.level = process.env.LOG_LEVEL
log.debug "Importing polling issues module"

###
    Function makes a request to server and pass json
    data to the callback function
###
get_new_issues_json = (callback)->
    options =
      host: global.remote_host,
      path: "/zd/new.json"
    log.verbose "Getting new issues...#{options.host+options.path}"
    req = http.get options,(res)->
        out = ''
        res.on 'data', (chunk)-> #collect data
            out = out + chunk
        res.on 'end', ()->
            jsdata = JSON.parse(out)
            callback(jsdata)



###
    Function invokes get_new_issues_json with the callback.
    Process json and creates directories and info.json for every record.
###
process_issues = ()->
    get_new_issues_json (jsdata)->
        for k,v of jsdata
            journal_dir = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{v.journal_id}")
            if !fs.existsSync journal_dir
                log.verbose "Creating #{journal_dir}"
                fs.mkdirSync journal_dir
            issue_dir = path.join(journal_dir, "#{v.id}")
            if !fs.existsSync issue_dir
                log.verbose "Creating #{issue_dir}"
                fs.mkdirSync issue_dir
            issue_page_dir = path.join(issue_dir,"pages")
            if !fs.existsSync issue_page_dir
                log.verbose "Creating #{issue_page_dir}"
                fs.mkdirSync issue_page_dir
            issue_covers_dir = path.join(issue_dir,"thumbnails")
            if !fs.existsSync issue_covers_dir
                log.verbose "Creating #{issue_covers_dir}"
                fs.mkdirSync issue_covers_dir
            request(v.thumb).pipe(fs.createWriteStream("#{issue_dir}/cover.png")).on 'close', ()->
            # save json file about journal if it does not exist
            dest = path.join(issue_dir,"info.json")
            ou = JSON.stringify(v)
            cont = fs.writeFileSync dest, ou




#get_issues_from_server = ()->
#    log.debug "Start request issues from .."

check_issue = (iv)->
    issue_dir = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{iv.journal_id}/#{iv.id}")
    cover_path = "#{issue_dir}/cover.png"
    if !fs.existsSync cover_path
        return false
    info_path = "#{issue_dir}/info.json"
    if !fs.existsSync info_path
        return false
    pages_path = "#{issue_dir}/pages.json"
    if !fs.existsSync pages_path
        return false
    return true
    
check_issues = ()->
    log.debug "Checking issues..."
    dest = path.join(global.app_root, global.app_config.data_dir, "catalog/catalog.json")
    jsondata = JSON.parse(fs.readFileSync dest, 'utf8')
    problem_issues = []
    for k,v of jsondata.categories
        for jk, jv of v.journals
            for ik, iv of jv.issues
                if !check_issue(iv)
                    if iv.id not in problem_issues
                       problem_issues.push iv
                else
                    done_dir = path.join(global.app_root, global.app_config.data_dir, 'journals', "#{iv.journal_id}/#{iv.id}/done.dat")
                    fs.writeFileSync done_dir, ''

    dest_pb =  path.join global.app_root, global.app_config.data_dir, 'problem_issue.json'
    ou = JSON.stringify(problem_issues)
    cont = fs.writeFileSync dest_pb, ou

poolling =
    process_issues: process_issues
    check_issues: check_issues
    check_issue: check_issue

module.exports = poolling #export for using outside
