package io.pomatti.app.event;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
@RequestMapping("/api/events")
public class ProducerApplication {

	@Autowired
	EventHubService eventHub;

	public static void main(String[] args) {
		SpringApplication.run(ProducerApplication.class, args);
	}

	@PostMapping("/")
	public Event post(@RequestBody Event order) {
		eventHub.publishEvents();
		return new Event();
	}

}
