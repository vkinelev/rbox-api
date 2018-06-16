// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"
import * as monaco from 'monaco-editor';

// self.MonacoEnvironment = {
// 	getWorkerUrl: function (moduleId, label) {
// 		return '';
// 	}
// }

export default class extends Controller {
  static targets = [ "output" ]

  initialize() {
    console.log('ready 1');
    this.editor = monaco.editor.create(document.getElementById('editor'), {
    	value: '',
    	language: 'ruby'
    });
  }

  connect() {
    // this.outputTarget.textContent = 'Hello, Stimulus!'
  }

  open(event) {
    console.log(event);

    const mainNode = document.getElementById('editor');
    //  = event.target.dataset.filename;
    const url =
    fetch(`/sandboxes/10/file_contents?filename=${event.target.dataset.filename}`)
      .then(response => response.text())
      .then(html => {
        this.editor.setValue(html);
      });
  }

  save() {
    var aFileParts = ['<a id="a"><b id="b">hey!</b></a>']; // an array consisting of a single DOMString
    var oMyBlob = new Blob(aFileParts, { type : 'text/html' }); // the blob

    var formData = new FormData();
    // formData.append('authenticity_token', document.querySelector("meta[name='csrf-token']").getAttribute("content"));
    formData.append('files[]', oMyBlob, 'app/test.rb');

    fetch('/sandboxes/10/save_changes', {
      method: 'POST',
      body: formData,
      credentials: 'same-origin',
      headers: {
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content")
      }
    })
  }
}
