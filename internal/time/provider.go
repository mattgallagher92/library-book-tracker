package time

import (
	"sync"
	"time"
)

type Provider interface {
	Now() time.Time
}

type RealProvider struct{}

func (p *RealProvider) Now() time.Time {
	return time.Now()
}

type SimulatedProvider struct {
	mu          sync.RWMutex
	currentTime time.Time
}

func NewSimulatedProvider(initial time.Time) *SimulatedProvider {
	return &SimulatedProvider{currentTime: initial}
}

func (p *SimulatedProvider) Now() time.Time {
	p.mu.RLock()
	defer p.mu.RUnlock()
	return p.currentTime
}

func (p *SimulatedProvider) SetTime(t time.Time) {
	p.mu.Lock()
	defer p.mu.Unlock()
	p.currentTime = t
}
