import sys
sys.path.insert(1, './src')

from fastapi import FastAPI, status
from fastapi.responses import HTMLResponse

import logging
from logging.config import dictConfig
from log_config import log_config 

dictConfig(log_config)
logger = logging.getLogger("capstone") # should be this name unless you change it in log_config.py

app = FastAPI()

@app.get('/healthcheck', status_code=status.HTTP_200_OK)
def perform_healthcheck():
    logger.info('Healthcheck ok')
    return {'healthcheck': 'Ok'}

@app.get("/")
async def main():
    content = """
<body>
<p>Hello World !</p>
</body>
    """
    return HTMLResponse(content=content)
