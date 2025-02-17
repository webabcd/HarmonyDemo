import sys
import asyncio

async def main(argv):
    import webapi.webserver
    await webapi.webserver.launch()
    await asyncio.Event().wait()

if __name__ == '__main__':
    asyncio.run(main(sys.argv[1:]))
    