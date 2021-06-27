# VendPractice

- func loadPhoto()
  - Fetch photos from web service and cache them in the photo pool
  - Get photos from the local repository and display them
  - Remove duplicated photos from photo pool, if the photo has been added
- func addRandomPhoto()
  - Get a random photo from the pool
  - Save the photo to the local repository 
  - Remove the photo from the pool 
- func delete(photo: Photo)
  - Delete the photo from the local repository
  - Delete the photo from the viewModel
  - Add the photo back to the pool
- func reorder(sourceIndex: Int, destinationIndex: Int)
  - Remove the photo from the viewModel
  - Insert the photo to the destination viewModel
  - Update photos display order in the local repository

