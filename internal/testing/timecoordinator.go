package testing

import (
	"context"
	"time"

	loansv1 "github.com/mattgallagher92/library-book-tracker/proto/loans/v1"
)

type TimeCoordinator struct {
	clients []loansv1.LoansServiceClient
}

func NewTimeCoordinator(clients []loansv1.LoansServiceClient) *TimeCoordinator {
	return &TimeCoordinator{
		clients: clients,
	}
}

func (c *TimeCoordinator) SetTime(t time.Time) error {
	req := &loansv1.UpdateSimulatedTimeRequest{
		Timestamp: t.Format(time.RFC3339),
	}
	
	for _, client := range clients {
		if _, err := client.UpdateSimulatedTime(context.Background(), req); err != nil {
			return err
		}
	}
	return nil
}

func (c *TimeCoordinator) AdvanceBy(d time.Duration) error {
	t := time.Now().Add(d)
	return c.SetTime(t)
}

func (c *TimeCoordinator) AdvanceDays(days int) error {
	return c.AdvanceBy(24 * time.Hour * time.Duration(days))
}
