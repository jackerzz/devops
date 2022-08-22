from fastapi import FastAPI
import uvicorn
app = FastAPI()


@app.post("/")
async def save_apifox_json(result:dict,collection:dict):
    return {"collection": "collection"}


if __name__ == '__main__':
    # 启动命令
    uvicorn.run(app='service:app', host="127.0.0.1", port=8000, reload=True, debug=True)
    