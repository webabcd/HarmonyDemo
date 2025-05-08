from aiohttp import web
import asyncio

def setup_routes(app):
    app.router.add_route('*', '/api', httpapi)
    app.router.add_route('*', '/redirect', httpapi_redirect)
    app.router.add_route('*', '/upload', httpapi_upload)

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

    await asyncio.sleep(3)
    return web.Response(text=result)


async def httpapi_redirect(request):
    return web.Response(status=302, headers={'Location': '/api?k1=v1&k2=v2'})


async def httpapi_upload(request):
    filepath =  request.headers.get('filename', 'unknown.unknown')

    with open(filepath, 'wb') as f:
        while True:
            chunk = await request.content.read(1024 * 1024) 
            if not chunk:
                break
            f.write(chunk)

    return web.json_response({'message': f'文件成功保存到 {filepath}'}, status=200)