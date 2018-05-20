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
}