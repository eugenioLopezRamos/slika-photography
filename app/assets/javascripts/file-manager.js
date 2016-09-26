

var fileManager = function(arrayOfFiles) {

	var root = document.getElementById("root");

	var myArray = arrayOfFiles;
	initialArray = "";

	var currentIndex = 0;
//	var fileREGEX = /([\w]+[.]*[\w]+\/)*([\w]+[.]*[\w]+.*\-*)/; //  gets all directories + filenames with . and -
//	var folderREGEX = /([\w]+[.]*[\w]+\/)*/; // all directories, excludes files - original regexes, changed for the current one


	var fileREGEX = /([\w*]+[.]*[\w]+\/)*(\w*[.]*[\w]+.*\-*\(*\)*\+*)/; //  gets all directories + filenames with . and -, (, ), +
	var folderREGEX = /([\w]+[.]*[\w]+\/\(*\)*\+*\-*)*/; // all directories, excludes files, incl chars -, (, ), +
	// var singleFolderREGEX = /([\w]+[.]*[\w]+\/)/; //get just a single folder - this one was never used


	//file.gsub(/(\w*[.]*[\w]+\/)*/, '') modified regex from the controller as reference

	var counter = 0; //only needed for testing (it prevents infinite loops with if counter > myArray.length)
	var currentFolder = root;
	var parentFolder = root;

	function createFolder(object, currIndex) {
			var object = object;

			var newFolder = (function createTheFolder() {
				var newFolder = document.createElement("ul");//.classList.add("folder");
				newFolder.classList.add("folder");
				var folderSpan = document.createElement("span");
				var folderSpanText = document.createTextNode(object.replace(parentFolder.id, ''));
				folderSpan.appendChild(folderSpanText);
				newFolder.appendChild(folderSpan);
				newFolder.id = object;
				return newFolder;
			})();


		currentFolder.appendChild(newFolder);

		if ((currIndex+1)<myArray.length && myArray[currIndex+1].includes(newFolder.id)) {
			currentFolder = newFolder;
		}
		else if(currIndex+1<myArray.length){
			var currentFolderValue = currentFolder.id;
			var nextItemValue = myArray[currIndex+1];

			//so, for example -> currentFolderValue = images/
			//					 nextItemValue = images/background/

			//					nextItemValue.split(currentFolderValue) = background/
			//	and then you resolve the outer .split() -> images/.split(background/) = images/ is the common parent of these 2 folders

			console.log("currFolderID", currentFolderValue);
			console.log("next val", myArray[currIndex+1]);
			currentFolder = document.getElementById(currentFolderValue.split(nextItemValue.split(currentFolderValue))) || root;
		} 

		return;
	}

	function createFile(object, currIndex) {

		var file = document.createElement("li");
		file.classList.add("file");
		var fileName = document.createTextNode(object.replace(folderREGEX, ''));
		file.appendChild(fileName);
		file.id = object;
		currentFolder.appendChild(file);

		if(currIndex+1<myArray.length){

			if(myArray[currIndex+1].includes(currentFolder.id)) {

					if(myArray[currIndex+1].match(folderREGEX).input === myArray[currIndex+1].match(folderREGEX)[0]){		
					
						currentFolder = (function() {

							while(!myArray[currIndex+1].includes(currentFolder.id) && currentFolder != root) {
								
								currentFolder = currentFolder.parentElement;
							}

							return currentFolder;

						})();

						return;
					}


					else if(myArray[currIndex+1].match(fileREGEX).input === myArray[currIndex+1].match(fileREGEX)[0]) {
						currentFolder = currentFolder;
						return;

					}

			}
			else {
				currentFolder = (function() {

					while(!myArray[currIndex+1].includes(currentFolder.id) && currentFolder != root) {
						
						currentFolder = currentFolder.parentElement;
					}

					return currentFolder;

				})();
			}

		}
		return;
	}

	function directorize(array) {

		array.map(function(element, index, array) {
			if(counter > myArray.length*5) {
				return;
			}
			else {
				if(element.match(folderREGEX).input === element.match(folderREGEX)[0]){
					//if element value == '*/' (that is, whatever value that ends in a slash), then the element is a folder
					currentIndex = index;
					counter = counter + 1;
					createFolder(element, currentIndex);
					return;
				}
				if(element.match(fileREGEX).input === element.match(fileREGEX)[0]){
					//element name is *, without a slash at the end, then it is a file.
					currentIndex = index;
					createFile(element, currentIndex);
					counter = counter + 1;
					return;
				}
				if(index+1>array.length) {
					return;
				}
			}
		});

	}

	directorize(myArray);


	function toggleSelectedState(event) {
		if(event.ctrlKey ===  true){
			event.target.classList.toggle('selected');
			return false;
		}
		else{
			return true;
		}
	}

	

	[].slice.call(document.getElementsByTagName("li")).map(function(element, index, array) { // hides all <li> by default...
		
		if(element.parentElement != root) {

		element.style.display = "none";
		}

		element.addEventListener("click", function(event) {		
			toggleSelectedState(event);	
		});
	});

	[].slice.call(document.getElementsByTagName("span")).map(function(element, index, array) { //but toggles them when you click the folder's <span>

		element.addEventListener("click", function(event) {
			var continueFunction = toggleSelectedState(event);
			if(!continueFunction) {
				return
			}
			else {""};


			[].slice.call(element.parentElement.children).slice(1).map(function(element,index, array) {
				element.style.display === "none" ? element.style.display = "" : element.style.display = "none";
			});

		});

	});

	$('#download-file').click(function(event) {
		event.preventDefault();

		//AJAX request sending the array of stuff to download (or just 1 thing) - Currently just one thing
		var req = new XMLHttpRequest();
	//	var params = '?files=';// + fullFileRoute;
		  // param is [:files]


		var fullFileRoute = (function() {
								var route = [];
							
								var selectedFiles = [];

								selectedFiles = [].slice.call(document.getElementsByClassName('selected'));

								selectedFiles.map(function(element, index, array) {
									var currentId = element.id;
									
									route.push(currentId);
								});
								console.log("route", route);


								/*route = route.reduce(function(previousValue, currentValue, index, array) {
									return previousValue + "&" + currentValue;
								});*/

								return route;
							})();

							//could also use multiple file downloads with rubyzip or something

		var formData = new FormData();
		var utf = document.querySelectorAll("input[name='utf8']")[0].getAttribute("value");
		var authenticityToken = document.querySelectorAll("input[name='authenticity_token']")[0].getAttribute("value");
		formData.append("utf-8", utf);
		formData.append("authenticity-token", authenticityToken);
		formData.append("files", JSON.stringify(fullFileRoute));



		req.open("POST", 'download_file', true);
		req.setRequestHeader('X-CSRF-TOKEN', document.querySelectorAll('meta[name="csrf-token"]')[0].getAttribute("content"));

		req.responseType = "blob";
		 

		req.onload = function (event) {
		  	if(req.status === 200) {

				var blob = req.response;
				var link=document.createElement('a');
				link.href=window.URL.createObjectURL(blob);
				var fileName = document.getElementsByClassName('selected')[0].id.replace(folderREGEX, '').split('.');
				link.download= fileName[0] + "." + fileName[1];
				link.click();
		
			}
			else if(req.status != 200) {

				var newReader = new FileReader();
				var incomingBlob = new Blob([req.response]);

				newReader.readAsText(incomingBlob);

				newReader.onload = function(event) {
					document.getElementById("messages").innerHTML = newReader.result;
				}
	
			}

			[].slice.call(document.getElementsByClassName('selected')).map(function(element, index, array) {
				element.classList.toggle('selected');
			});

		};

			req.send(formData);
			$.ajax({url: 'download_file', type: 'GET', contentType: 'application/json'}).done(function(response){
				alert(response);
			});

		});

	$('#delete-files').click(function(event){
		event.preventDefault();
		var deleteArray = (function() {
								var selected = [];
								[].slice.call(document.getElementsByClassName('selected')).map(function(element, index, array) {

									selected.push(element.id);
								});
								return selected;
							})();
		$.ajax({url: "delete_file", data: JSON.stringify({files:deleteArray}) , type: 'DELETE', contentType: 'application/json'}).done(function(response) {
			
				document.getElementById("messages").innerHTML = response;



				[].slice.call(document.getElementsByClassName('selected')).map(function(element, index, array) {
					var currentChildToRemove = document.getElementById(element.id);
					element.parentElement.removeChild(currentChildToRemove);
				});


			//	selected.parentElement.removeChild(selected.id)
				//also need to remove the selected items from the tree
		});
		//AJAX sending the array/method to use to delete the files we need to delete

	});


	/*document.getElementsByClassName('upload-btn')[0].addEventListener('change', function() {
		var size_megabytes = this.files[0].size/1024/1024
		if(size_megabytes > 5){
			alert('Maximum file size is 5 MB. Please choose a smaller file')
			}
	});*/ //need to edit, probably will set a max size of 50mb per mass upload, then verify on the backend so I dont have trouble with disk space



	$('#upload-file').click(function(event){
		event.preventDefault();

		var uploadRoute;

		if(document.getElementsByClassName('selected').length > 0) {
			uploadRoute = document.getElementsByClassName('selected')[0].innerText;
		}
		else {
			uploadRoute = "";
		}
		


		var filesToUpload = document.getElementById('file_input_field').files
		console.log("files", filesToUpload);

		if(filesToUpload.length<1) {
			alert("No files selected for upload");
			return;
		}

		document.getElementById('upload-file').disabled = true;

		var formData = new FormData();
		var utf = document.querySelectorAll("input[name='utf8']")[0].getAttribute("value");
		var authenticityToken = document.querySelectorAll("input[name='authenticity_token']")[0].getAttribute("value");
		formData.append("utf-8", utf);
		formData.append("authenticity-token", authenticityToken);
		formData.append("file_route", uploadRoute);

		[].slice.call(filesToUpload).map(function(element, index, array) {

			if(!element.type.match('image.*')) {
			
			return;
			}
			else {
				formData.append("image[]", element, element.name);
			}

		});

		var xhr = new XMLHttpRequest();
		xhr.open('POST', 'upload', true);
		xhr.setRequestHeader('X-CSRF-TOKEN', document.querySelectorAll('meta[name="csrf-token"]')[0].getAttribute("content"));

		xhr.send(formData);
		xhr.onload = function() {

			if(xhr.status === 200) {
			
				document.getElementById("messages").innerHTML = xhr.response;
				[].slice.call(document.getElementsByClassName('selected')).map(function(element, index, array) {
					element.classList.toggle('selected');
				});

			}

			if(xhr.status === 500) {
				alert("woops! an error has occurred");
			}

		document.getElementById('upload-file').disabled = false;
		document.getElementById('file_input_field').value = "";

		}




	});

	$('#upload-file-form').submit(function(event) {
	event.preventDefault();

	});


} // end file-manager function

$(document).ready(fileManager(initialArray));
