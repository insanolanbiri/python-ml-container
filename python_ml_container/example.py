"""Example of a Python module that includes functions for training \
    and testing a model with TensorFlow."""

import tensorflow as tf


def create_model() -> tf.keras.models.Sequential:
    """Creates a simple Keras model for testing purposes."""
    model = tf.keras.models.Sequential(
        [
            tf.keras.layers.Conv2D(32, 3, activation="relu", input_shape=(28, 28, 1)),
            tf.keras.layers.Flatten(),
            tf.keras.layers.Dense(128, activation="relu"),
            tf.keras.layers.Dropout(0.2),
            tf.keras.layers.Dense(10, activation="softmax"),
        ]
    )

    model.compile(
        optimizer="adam", loss="sparse_categorical_crossentropy", metrics=["accuracy"]
    )

    return model


def preprocess_dataset(dataset: tuple) -> tuple:
    """Preprocesses a MNIST-like dataset for training a model.

    Args:
        dataset: Tuple containing the MNIST dataset.

    Returns:
        Tuple containing the preprocessed MNIST dataset.
    """
    (x_train, y_train), (x_test, y_test) = dataset

    # Add a channels dimension
    x_train = x_train[..., tf.newaxis].astype("float32")
    x_test = x_test[..., tf.newaxis].astype("float32")

    # Normalize the input data
    x_train, x_test = x_train / 255.0, x_test / 255.0

    return (x_train, y_train), (x_test, y_test)


def train_model(
    model: tf.keras.models.Sequential, dataset: tuple, epochs: int = 5
) -> None:
    """Trains a model with the MNIST-like dataset.

    Args:
        model: A Keras model.
        dataset: Tuple containing the MNIST-like dataset.
        epochs: Number of epochs to train the model.
    """
    (x_train, y_train), (x_test, y_test) = dataset

    try:
        model.fit(x_train, y_train, epochs=epochs, validation_data=(x_test, y_test))
    except KeyboardInterrupt:
        print("\nTraining interrupted.")


def main() -> None:
    """Main function."""

    # Uncomment the following lines if you want to use a GPU with low memory.
    for gpu in tf.config.experimental.list_physical_devices("GPU"):
        tf.config.experimental.set_memory_growth(gpu, True)

    print("==========")
    print("Physical devices:")
    print(tf.config.list_physical_devices())
    print("==========")
    dataset = tf.keras.datasets.mnist
    dataset = preprocess_dataset(dataset.load_data())

    model = create_model()
    train_model(model, dataset)


if __name__ == "__main__":
    main()
