from aiohttp import web
import json

def setup_routes(app):
    app.router.add_route('*', '/api', httpapi)

async def launch():
    app = web.Application()
    runner = web.AppRunner(app)
    setup_routes(app)
    await runner.setup()
    site = web.TCPSite(runner, '0.0.0.0', 8001)
    await site.start()


async def httpapi(request):
    k1 = request.query.get('k1', '')
    k2 = request.query.get('k2', '')
    
    h1 = request.headers.get('custom-header1', '')
        
    data = await request.content.read()
    postData = data.decode()
        
    result = f"method:{request.method}, k1:{k1}, k2:{k2}, h1:{h1}, postData:{postData}"

    return web.Response(text=result)

    try:
        db = sqlite.Connect(config.db_path)
        taskId = dict["ID"]
        priority = dict["Priority"]

        source_url = dict["Source"]
        source_language = ''
        target_language = dict["Language"]
        if source_language == '' or source_language == 'auto':
            ...
        elif source_language not in config.settings_nllb_language:
            raise MyException(301, f"语言 {source_language} 不支持，目前支持的语言有：{','.join(config.settings_nllb_language.keys())}")
        if target_language == '':
            ...
        else:
            unsupported_language = set(target_language.split(',')).difference(set(config.settings_nllb_language.keys()))
            if len(unsupported_language) > 0:
                raise MyException(301, f"语言 {','.join(unsupported_language)} 不支持，目前支持的语言有：{','.join(config.settings_nllb_language.keys())}")

        # 先删除同 taskid 的数据，因为更新逻辑是根据 id 更新的，所以运行中的逻辑完成后是找不到可更新的数据的，所以不会和后面新加进来的同 taskid 数据发生冲突
        # db.table('task').delete(f'where taskid=\'{taskId}\'')

        task_status = await get_task_status(dict, resetIfFailed=True)
        if task_status[0] == 102: # 无此任务
            ...
        else:
            return task_status
        
        step_list = config.task_step_list_default
        if source_url.endswith(".srt"):
            step_list = config.task_step_list_translate

        db.table('task').add({
            'id': common.get_uuid(), 
            'taskid': taskId, 
            'priority': str(priority), 
            'data': json.dumps(dict), 
            'ext': "",
            'step': step_list[0], 
            'steplist': ",".join(step_list), 
            'status': 0, 
            'createtime': common.sqlite_time2str(common.get_time()), 
            'updatetime': common.sqlite_time2str(common.get_time()), 
            'log': ""
        })
        return 0, "ok"
    #except sqlite3.IntegrityError as ex:
        #raise MyException(101, "任务正在排队")
    except Exception as ex:
        raise ex
    finally:
        db.close()