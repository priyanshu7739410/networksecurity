.PHONY: build run stop clean

build:
	docker-compose build

run:
	docker-compose up

stop:
	docker-compose down

clean:
	python -c "import shutil, glob; [shutil.rmtree(p, ignore_errors=True) for p in ['Artifacts', 'logs', 'prediction_output', 'valid_data', 'final_model', 'build', 'dist', '.pytest_cache']]; [shutil.rmtree(p, ignore_errors=True) for p in glob.glob('*.egg-info')]; [shutil.rmtree(p, ignore_errors=True) for p in glob.glob('**/__pycache__', recursive=True)]"
	docker system prune -f

