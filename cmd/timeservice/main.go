package main

import (
	"context"
	"log"
	"net"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	borrowernotificationv1 "github.com/mattgallagher92/library-book-tracker/proto/borrower_notification/v1"
	loansv1 "github.com/mattgallagher92/library-book-tracker/proto/loans/v1"
	timev1 "github.com/mattgallagher92/library-book-tracker/proto/time/v1"
)

type timeServer struct {
	timev1.UnimplementedTimeServiceServer
	loansClient              loansv1.LoansServiceClient
	borrowerNotificationClient borrowernotificationv1.BorrowerNotificationServiceClient
	currentTime             time.Time
}

func (s *timeServer) SetTime(ctx context.Context, req *timev1.SetTimeRequest) (*timev1.SetTimeResponse, error) {
	t, err := time.Parse(time.RFC3339, req.Timestamp)
	if err != nil {
		return nil, err
	}
	
	// Update loans service time
	if _, err = s.loansClient.UpdateSimulatedTime(ctx, &loansv1.UpdateSimulatedTimeRequest{
		Timestamp: req.Timestamp,
	}); err != nil {
		return nil, err
	}

	// Update borrower notifications service time
	if _, err = s.borrowerNotificationClient.UpdateSimulatedTime(ctx, &borrowernotificationv1.UpdateSimulatedTimeRequest{
		Timestamp: req.Timestamp,
	}); err != nil {
		return nil, err
	}
	s.currentTime = t
	return &timev1.SetTimeResponse{}, nil
}

func (s *timeServer) AdvanceBy(ctx context.Context, req *timev1.AdvanceByRequest) (*timev1.AdvanceByResponse, error) {
	newTime := s.currentTime.Add(time.Duration(req.Seconds) * time.Second)
	timestamp := newTime.Format(time.RFC3339)
	
	_, err := s.SetTime(ctx, &timev1.SetTimeRequest{Timestamp: timestamp})
	if err != nil {
		return nil, err
	}
	
	return &timev1.AdvanceByResponse{
		NewTimestamp: timestamp,
	}, nil
}

func main() {
	log.Println("Time coordination service starting...")

	// Connect to loans service
	loansConn, err := grpc.Dial("localhost:50051", grpc.WithInsecure())
	if err != nil {
		log.Fatalf("Failed to connect to loans service: %v", err)
	}
	defer loansConn.Close()
	loansClient := loansv1.NewLoansServiceClient(loansConn)

	// Connect to borrower notifications service
	notificationsConn, err := grpc.Dial("localhost:50053", grpc.WithInsecure())
	if err != nil {
		log.Fatalf("Failed to connect to borrower notifications service: %v", err)
	}
	defer notificationsConn.Close()
	notificationsClient := borrowernotificationv1.NewBorrowerNotificationServiceClient(notificationsConn)

	// Create and start server
	server := grpc.NewServer()
	timev1.RegisterTimeServiceServer(server, &timeServer{
		loansClient:              loansClient,
		borrowerNotificationClient: notificationsClient,
		currentTime:              time.Now(),
	})

	lis, err := net.Listen("tcp", ":50052")
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	reflection.Register(server)
	log.Printf("Server listening on :50052")
	if err := server.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
