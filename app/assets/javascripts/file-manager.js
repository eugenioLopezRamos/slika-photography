

var fileManager = function(arrayOfFiles) {

	//This function takes an arrayOfFiles, which is the response of an Aws::S3::Client.list_objects request to S3
	// and "directorizes" it (that is, each [index] is checked to see if its a folder or a file, then an HTML element is created
	// and nested in a structure similar to desktop OS directories, then event listeners/handlers are assigned)
	//


/***************					DIRECTORIZER			******************/


	var root = document.getElementById("root");

	var myArray = arrayOfFiles;

	delete window.initialArray; //deletes the global initialArray var.

	var currentIndex = 0;

	function createMessageBoxMsg(type, message) {

		document.querySelector("#messages").innerHTML = "";

		var newDiv = document.createElement("div");
		newDiv.classList.add("message-box");
		document.querySelector("#messages").appendChild(newDiv);
		
		var messageContainer = document.createElement("div");
		messageContainer.classList.add("alert");
		messageContainer.classList.add("alert-" + type);
		messageContainer.innerText = message;


		newDiv.appendChild(messageContainer);

		
		
	}

//	var fileREGEX = /([\w*]+[.]*[\w]+\/)*(\w*[.]*[\w]+.*\-*\(*\)*\+*)/; //  gets all directories + filenames with "." and "-", "(", ")", "+"
//	var folderREGEX = /([\w]+[.]*[\w]+\/\(*\)*\+*\-*)*/; // all directories, excludes files, incl chars "-", "(", ")", "+"


	var fileREGEX = /([\w]+.*[\w]+\/{1})*(.*)/	//new regexes
	var folderREGEX = /([\w]+.*[\w]+\/{1})*/
	var counter = 0; //only needed for testing/as a failsafe (it prevents infinite loops by comparing counter
	//counter to myArray.length and stopping if counter > myArray.length * <value> )
	var currentFolder = root;
	var parentFolder = root;

	var doubleClick = 0;

	function createFolder(object, currIndex) {
	    var object = object;

	    var newFolder = (function createTheFolder() {
	        var newFolder = document.createElement("ul"); //.classList.add("folder");
	        newFolder.classList.add("folder");
	        var folderSpan = document.createElement("span");
	        var folderSpanText = document.createTextNode(" "+object.replace(parentFolder.id, ''));
			var folderIcon = document.createElement("img");
			folderIcon.setAttribute("src", "/images/external/folder-icon.png");


			folderSpan.appendChild(folderIcon);
	        folderSpan.appendChild(folderSpanText);
			folderSpan.id = object;
	        newFolder.appendChild(folderSpan);
	        newFolder.id = object;
	        return newFolder;
	    })();


	    currentFolder.appendChild(newFolder);

	    if ((currIndex + 1) < myArray.length && myArray[currIndex + 1].includes(newFolder.id)) {
	        currentFolder = newFolder;
	    } else if (currIndex + 1 < myArray.length) {
	        var currentFolderValue = currentFolder.id;
	        var nextItemValue = myArray[currIndex + 1];

	        //so, for example -> currentFolderValue = images/
	        //					 nextItemValue = images/background/

	        //					nextItemValue.split(currentFolderValue) = background/
	        //	and then you resolve the outer .split() -> images/.split(background/) = images/ is the common parent of these 2 folders
	        currentFolder = document.getElementById(currentFolderValue.split(nextItemValue.split(currentFolderValue))) || root;
	    }

	    return;
	}

	function createFile(object, currIndex) {

	    var file = document.createElement("li");
	    file.classList.add("file");
	    var fileName = document.createTextNode(object.replace(folderREGEX, ''));
		var fileIcon = document.createElement("img");
		fileIcon.setAttribute("src", "/images/external/file-icon.png");
		//<img src="/images/external/file-icon.png"> img code
		file.appendChild(fileIcon);
	    file.appendChild(fileName);
	    file.id = object;
	    currentFolder.appendChild(file);

	    if (currIndex + 1 < myArray.length) {

	        if (myArray[currIndex + 1].includes(currentFolder.id)) {

	            if (myArray[currIndex + 1].match(folderREGEX).input === myArray[currIndex + 1].match(folderREGEX)[0]) {

	                currentFolder = (function() {

	                    while (!myArray[currIndex + 1].includes(currentFolder.id) && currentFolder != root) {

	                        currentFolder = currentFolder.parentElement;
	                    }

	                    return currentFolder;

	                })();

	                return;
	            } else if (myArray[currIndex + 1].match(fileREGEX).input === myArray[currIndex + 1].match(fileREGEX)[0]) {
	                currentFolder = currentFolder;
	                return;

	            }

	        } else {
	            currentFolder = (function() {

	                while (!myArray[currIndex + 1].includes(currentFolder.id) && currentFolder != root) {

	                    currentFolder = currentFolder.parentElement;
	                }

	                return currentFolder;

	            })();
	        }

	    }
	    return file;
	}

	function directorize(array) {

	    array.map(function(element, index, array) {
	        if (counter > myArray.length * 5) {
	            return;
	        } else {
	            if (element.match(folderREGEX).input === element.match(folderREGEX)[0]) {
	                //if element value == '*/' (that is, whatever value that ends in a slash), then the element is a folder
	                currentIndex = index;
	                counter = counter + 1;
	                createFolder(element, currentIndex);
	                return;
	            }
	            if (element.match(fileREGEX).input === element.match(fileREGEX)[0]) {
	                //element name is *, without a slash at the end, then it is a file.
	                currentIndex = index;
	                createFile(element, currentIndex);
	                counter = counter + 1;
	                return;
	            }
	            if (index + 1 > array.length) {
	                return;
	            }
	        }
	    });
		//here there should be a function to sort by inserting the folders first
		


	}

	directorize(myArray);

	function sortDirectory(startFolder, firstItemType){
		if(startFolder.childElementCount > 0) {
			var startFolder = startFolder; //where to start ordering
			var itemTypes = ["file", "folder"];

			var firstItemType = itemTypes.findIndex(function(element) { 

				if(element === firstItemType) {
					return element;
				}

			});

			firstItemType = itemTypes.splice(firstItemType, 1); //should be either "file" or "folder"

			var secondItemType = itemTypes; // this is just for clarity, the itemTypes array was modified w/ the .splice.

			var removedElements = [];
			var childrenOfFolder = [].slice.call(startFolder.children);

			childrenOfFolder.map(function(element) {

				if(element.classList.contains(firstItemType) && element.parentElement === startFolder) {
				
					var firstChild = (function() { // This is the first child that ISN'T the type that we specified as firstItemType.

						for(i=0; i<childrenOfFolder.length; i++) {

							if(childrenOfFolder[i].classList.contains(secondItemType) && childrenOfFolder[i].parentElement === startFolder) {
								return childrenOfFolder[i];
							}

						} //close for loop

					})(); //close firstChild IIFE

				
					element.parentElement.insertBefore(element, firstChild);//element.parentElement.firstChild);

					}
				}); //close childrenOfFolder map


			var nextFolders = [].slice.call(startFolder.children).filter(function(element) { 

					if(element.classList.contains("folder") && element.childElementCount > 0) {
						return element;
					} 

				}); //close nextFolders

			nextFolders.map(function(element){

				sortDirectory(element, firstItemType[0]);

			}); //close nextFolders map

		
		} //close if childElementCount

	} //close sortDirectory

	sortDirectory(root, "folder");


	/**********************			ASSIGN HANDLERS/EVENT LISTENERS ETC				*****************************/
	function toggleSelectedState(event) {
		   	
	    event.target.classList.toggle('selected');        
		return true;
	}


	[].slice.call(document.getElementsByTagName("li")).map(function(element, index, array) { // hides all <li> by default...

	    if (element.parentElement != root) {

	        element.style.display = "none";
	    }

	    element.addEventListener("click", function(event) {
		
	        toggleSelectedState(event);
		
	    });
	});

	[].slice.call(document.querySelectorAll(".upload-dir-container span")).map(function(element, index, array) { //but toggles them when you click the folder's <span>
		
		if(element.parentElement.parentElement != root) {
			element.style.display = "none";
		}

	    element.addEventListener("click", function(event) {
			var continueFunction = false;
			var clickedTarget = event.target;


			doubleClick++;

			window.setTimeout(function(){

	        	if(doubleClick < 2 & !continueFunction) {
					var outerElement = element;
					outerElement.classList.toggle("open");

					[].slice.call(outerElement.parentElement.children).map(function(innerElement, index, array) { 

						var newId = innerElement.parentElement.id.replace(/(\/)+/g, "\\/");
	
						if (outerElement != innerElement){

				
							if(outerElement.classList.contains("open")) {
								innerElement.style.display = "";

								[].slice.call(document.querySelectorAll("#" + newId  + " span")).map(function(element, index, array) {

									if(clickedTarget != element) {
										element.style.display = "";
									}
									
								});
							}
							else {
								innerElement.style.display = "none";
								
								[].slice.call(document.querySelectorAll("#" + newId + " span")).map(function(element, index, array) {

									if(clickedTarget != element) {
										element.style.display = "none";
									}
								

								});

							}
						} 
					});
				}
				doubleClick = 0;
			}, 300)

			if(doubleClick>1) {
	        	continueFunction = toggleSelectedState(event);
				return;
			}
	    });

	});

	document.getElementById('file_input_field').addEventListener('click', function(event) {

		event.target.style.pointerEvents = "none"; // CSS disables the choose file button after click

		window.setTimeout(function(){// restores the default behavior 1s after disabling.
		event.target.style.pointerEvents = "auto";
		}, 1000 );

	});

	document.getElementById('file_input_field').addEventListener('change', function() {
		var maxMBs = 50; //max mb for uploads
		var caller = this; //the element that changed.In this case, since it's an id it's unique anyway.
		
		var sizeInMBs = (function(){
									var totalSize = 0;
									var i = 0;
									console.log("caller", caller);
									console.log("working");
									for (i = 0; i<caller.files.length; i++) {

										totalSize =+ caller.files[i].size;
										console.log("size", totalSize);
									}
									totalSize = totalSize/1024/1024;
									return totalSize;
							
								})();

		if(sizeInMBs > maxMBs){

			caller.value = "";
			alert('Total size of uploaded files is over the maximum allowed (' + maxMBs + 'MB).');

			}
		else {
		
			populateFileDashboard(caller.files, "file-name");

		}

		//añadir que al cambiar se  borren todos los existentes
		
 
		function populateFileDashboard(fileset, folderId) {

			var oldCurrentFolder = currentFolder; //I have to refactor that function, but for now this should do.
			function newDivider() {
			//	var hr = document.createElement("hr");
		//		hr.classList.add("file-info");
			//	return hr;

			}

			if(document.getElementsByClassName("file-info").length > 0) {

				[].slice.call(document.getElementsByClassName("file-info")).map(function(element, index, array) {
					element.parentElement.removeChild(element);
				});
				//remove each element.
			}
			

			var myArray = [].slice.call(fileset).map(function(element, index,array) {	
				return element;
			});
			
			myArray.map(function(element, index, array) {

				currentFolder = document.getElementById(folderId); //yes it's brute forcing the existing function. Needs refactor. To be done later. 
				var createdEntry = createFile(element.name, index);
				createElementGroup(element);
				createdEntry.classList.remove("file");
				createdEntry.classList.add("file-info", "name");

			});


			currentFolder = oldCurrentFolder; //Then afterwards we go back to the same as before we started.
		//	createFile(); //needds array element + its index

		function createElementGroup(element) {
			//this function creates the different files the uploader creates:
				//assuming Full HD original asset:

				//base version (full hd)
				//HD version (fit for 1366*768 res screens)
				//tablet version (900*600 approx. dimensions)


				//smaller versions would create up to the original size, that is:
				// a 900*600 image would only create 1 version: mobile
				// a 1200*700 image would create an HD version and a tablet version..


				var newHr = newDivider();

				var newLi = document.createElement("li");
				newLi.classList.add("file-info", "size");
				newLi.id = element.name + "-size";
				newLi.innerText = parseInt(element.size/1024, 10) + " kb";
				

				document.getElementById("file-original-size").appendChild(newLi);

				var newButton = document.createElement("button");
				var newButton2 = document.createElement("button");
				newButton.classList.add("file-info", "get-processed-data-btn")
				newButton.id = element.name + "-getProcessedData";

				newButton2.classList.add("file-info", "preview-file-btn")				
				newButton2.id = element.name + "-previewFile";

				newButton.innerText = "Get size";

				newButton2.innerText = "Preview File";
				
				document.getElementById("file-compressed-size").appendChild(newButton);

				document.getElementById("file-serverside-info").appendChild(newButton2);
	
	
		}



		}



	}); 

	/******						AJAX REQUEST HANDLERS							********/

	$('#download-file').click(function(event) {
	    event.preventDefault();

	    //AJAX request sending the array of stuff to download (or just 1 thing) - Currently just one thing
	    var req = new XMLHttpRequest();

	    var fullFileRoute = (function() {
	        var route = [];

	        var selectedFiles = [];

	        selectedFiles = [].slice.call(document.getElementsByClassName('selected'));

	        selectedFiles.map(function(element, index, array) {
	            var currentId = element.id;

	            route.push(currentId);
	        });

	        return route;

	    })();

	    var formData = new FormData();
	    var utf = document.querySelectorAll("input[name='utf8']")[0].getAttribute("value");
	    var authenticityToken = document.querySelectorAll("input[name='authenticity_token']")[0].getAttribute("value");
	    formData.append("utf-8", utf);
	    formData.append("authenticity-token", authenticityToken);
	    formData.append("files", JSON.stringify(fullFileRoute));



	    req.open("POST", 'download_file', true);
	    req.setRequestHeader('X-CSRF-TOKEN', document.querySelectorAll('meta[name="csrf-token"]')[0].getAttribute("content"));

	    req.responseType = "blob";

	    req.onload = function(event) {

	        if (req.status === 200) {

	            var blob = req.response;
	            var link = document.createElement('a');
	            link.href = window.URL.createObjectURL(blob);
	         
	            var fileName = "download.zip"; 
	            link.download = fileName; 
	            link.click();

	        } else if (req.status != 200) {

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

	        //get messages from the server
	        $.ajax({

	            url: 'download_file',
	            type: 'GET',
	            data: {
	                "authenticity-token": authenticityToken
	            }

	        }).done(function(response) {

	            $('#messages').html(response);

	        }).fail(function(response) {

	            $('#messages').html("Woops, couldn't retrieve messages from the server");

	        });
		
	    };

	    req.send(formData);

		createMessageBoxMsg("info", "In progress...");
	
	});

	$('#delete-files').click(function(event) {
	    event.preventDefault();
	    var deleteArray = (function() {
	        var selected = [];
	        [].slice.call(document.getElementsByClassName('selected')).map(function(element, index, array) {

	            selected.push(element.id);
	        });
	        return selected;
	    })();

	    $.ajax({
	        url: "delete_file",
	        data: JSON.stringify({
	            files: deleteArray
	        }),
	        type: 'DELETE',
	        contentType: 'application/json',
			beforeSend: createMessageBoxMsg("info", "In progress...")
	    }).done(function(response) {

	        document.getElementById("messages").innerHTML = response;
	        [].slice.call(document.getElementsByClassName('selected')).map(function(element, index, array) {

	            var currentChildToRemove = document.getElementById(element.id);
	            element.parentElement.removeChild(currentChildToRemove);

	        });
	    });
	
	    //AJAX sending the array/method to use to delete the files we need to delete

	});
 //need to edit, probably will set a max size of 50mb per mass upload, then verify on the backend so I dont have trouble with disk space



	$('#upload-file').click(function(event) {

	    event.preventDefault();

	    var uploadRoute;
		var selectedFiles = document.getElementsByClassName('selected');
	    if (selectedFiles.length === 1) {
	        uploadRoute = selectedFiles[0].innerText;
	    } else if (selectedFiles.length > 1)  {

			var answer = window.confirm("Files will be uploaded to the first selected folder:\n" + selectedFiles[0].innerText +//
			"\n Do you wish to continue?")

			if (!answer) {
				return;
			}
			else {
				uploadRoute = selectedFiles[0].innerText;
				[].slice.call(selectedFiles).map(function(element, index, array) {
					if(index != 0) {
						element.classList.remove("selected");
					}
				});
			}

		}
		else {
	        uploadRoute = "";
	    }


	    var filesToUpload = document.getElementById('file_input_field').files

	    if (filesToUpload.length < 1) {
	        alert("No files selected for upload");
	        return;
	    }

	    document.getElementById('upload-file').disabled = true; //disables the upload button until the upload request is resolved.

	    var formData = new FormData();
	    var utf = document.querySelectorAll("input[name='utf8']")[0].getAttribute("value");
	    var authenticityToken = document.querySelectorAll("input[name='authenticity_token']")[0].getAttribute("value");
	    formData.append("utf-8", utf);
	    formData.append("authenticity-token", authenticityToken);
	    formData.append("file_route", uploadRoute);

	    [].slice.call(filesToUpload).map(function(element, index, array) {

	        if (!element.type.match('image.*')) {

	            return;
	    	} else {
	            formData.append("image[]", element, element.name);
	        }

	    });

	    var xhr = new XMLHttpRequest();
	    xhr.open('POST', 'upload', true);
	    xhr.setRequestHeader('X-CSRF-TOKEN', document.querySelectorAll('meta[name="csrf-token"]')[0].getAttribute("content"));

	    xhr.send(formData);
		createMessageBoxMsg("info", "In progress...")

	    xhr.onload = function() {

	        if (xhr.status === 200) {

	            document.getElementById("messages").innerHTML = xhr.response;
	            [].slice.call(document.getElementsByClassName('selected')).map(function(element, index, array) {
	                element.classList.toggle('selected');
	            });

				//create a virtual element that's used to make us able to extract the HTML from the response
				var uploadsDummy = document.createElement("div");
				uploadsDummy.className = "dummy";
				uploadsDummy.id = "file-upload-dummy";
				$("#file-upload-dummy").html(xhr.response);
				document.body.appendChild(uploadsDummy);

				[].slice.call(document.getElementsByClassName("uploaded-file-list-item")).map(function(element, index, array) { //really really should have made this into a named function by now.
					console.log("list of uploads", document.getElementsByClassName("uploaded-file-list-item"));

					var file = element.innerHTML;	
					var folder = element.innerHTML.split("/");
					folder.splice(folder.length - 1);
					folder = folder.join("/") + "/";



					document.getElementById(folder) ? folder = document.getElementById(folder) : folder = root;

					var oldCurrentFolder = currentFolder;
		
					currentFolder = folder;

					if (!document.getElementById(file)) {
						createFile(file, myArray.length); //also need to refactor that.
						
					}
					if(folder != root && !folder.firstChild.classList.contains("open")) {

						document.getElementById(file).style.display = "none";
					}

					//need to add the click evt listener
					document.getElementById(file).addEventListener("click", function(event) {
		
	        			toggleSelectedState(event);
		
	   				 });

					currentFolder = oldCurrentFolder;
				
				});

				document.body.removeChild(uploadsDummy);
				


	        }

	        if (xhr.status === 500) {
	            alert("woops! an error has occurred");
	        }

	        document.getElementById('upload-file').disabled = false;
	        document.getElementById('file_input_field').value = "";
			var evt = new Event("change");
			document.getElementById('file_input_field').dispatchEvent(evt); //clears the preparation area, the change evt doesnt trigger naturally when setting value to ""
	    }


	});

	$('#upload-file-form').submit(function(event) {
		
	    event.preventDefault();

	});


	} // end file-manager function

	$(document).ready(fileManager(initialArray));