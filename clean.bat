@echo off
echo Cleaning local project artifacts...
python -c "import shutil, glob; [shutil.rmtree(p, ignore_errors=True) for p in ['Artifacts', 'logs', 'prediction_output', 'valid_data', 'final_model', 'build', 'dist', '.pytest_cache']]; [shutil.rmtree(p, ignore_errors=True) for p in glob.glob('*.egg-info')]; [shutil.rmtree(p, ignore_errors=True) for p in glob.glob('**/__pycache__', recursive=True)]"
echo Local cleanup complete.

echo Cleaning Docker system...
docker system prune -f
echo Docker cleanup complete.
