class NetworkModel:
    def __init__(self, preprocessor, model):
        try:
            self.preprocessor = preprocessor
            self.model = model
        except Exception as e:
            raise e

    def predict(self, x):
        try:
            transformed_feature = self.preprocessor.transform(x)
            return self.model.predict(transformed_feature)
        except Exception as e:
            raise e

    def __repr__(self):
        return f"{type(self.model).__name__}()"

    def __str__(self):
        return f"{type(self.model).__name__}()"
