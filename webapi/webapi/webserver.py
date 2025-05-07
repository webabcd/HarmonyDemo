from aiohttp import web
import asyncio
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

    await asyncio.sleep(3)
    return web.Response(text=result)