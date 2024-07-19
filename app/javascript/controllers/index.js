// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import FlatpickrController from "./flatpickr_controller"
application.register("flatpickr", FlatpickrController)

import MyModalController from "./my_modal_controller"
application.register("my-modal", MyModalController)

import FlashController from "./flash_controller.js"
application.register("flash", FlashController)