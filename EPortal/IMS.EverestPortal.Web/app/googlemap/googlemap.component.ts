import { OnInit, OnChanges, Input } from '@angular/core';
import { Http } from '@angular/http';
import { NgForm } from '@angular/forms';
import { Component, NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AgmCoreModule } from 'angular2-google-maps/core';

@Component({
    selector: 'my-app',
    styles: [`
    .sebm-google-map-container {
       height: 350px;
     }
  `],
    templateUrl: '../../app/googlemap/googlemap.component.html',
})
export class GoogleMapComponent {
    // google maps zoom level
    zoom: number = 16;
    title = 'Google map - Bricks';
    // initial center position for the map
    lat: number = -33.821192725760476;
    lng: number = 151.19756653904915;

    clickedMarker(label: string, index: number) {
        console.log(`clicked the marker: ${label || index}`)
    }

    mapClicked($event: any) {
        console.log($event);
    }

    markerDragEnd(m: marker, $event: MouseEvent) {
        console.log('dragEnd', m, $event);
    }

    markers: marker[] = [
        {
            lat: -33.821192725760476,
            lng: 151.19756653904915,
            label: 'A',
            draggable: true
        },
        {
            lat: -33.823599279636255,
            lng: 151.19855526834726,
            label: 'B',
            draggable: true
        },
        {
            lat: -33.822119702679984,
            lng: 151.19707468897104,
            label: 'C',
            draggable: true
        }
    ]
}
// just an interface for type safety.
interface marker {
    lat: number;
    lng: number;
    label?: string;
    draggable: boolean;
}

