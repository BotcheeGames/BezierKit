//
//  QuadraticBezierCurve.swift
//  BezierKit
//
//  Created by Holmes Futrell on 3/3/17.
//  Copyright © 2017 Holmes Futrell. All rights reserved.
//

import CoreGraphics

public struct QuadraticBezierCurve: NonlinearBezierCurve, ArcApproximateable, Equatable {
    
    public var p0, p1, p2: CGPoint
    
    public init(points: [CGPoint]) {
        precondition(points.count == 3)
        self.p0 = points[0]
        self.p1 = points[1]
        self.p2 = points[2]
    }
    
    public init(p0: CGPoint, p1: CGPoint, p2: CGPoint) {
        self.p0 = p0
        self.p1 = p1
        self.p2 = p2
    }
    
    public init(lineSegment l: LineSegment) {
        self.init(p0: l.p0, p1: 0.5 * (l.p0 + l.p1), p2: l.p1)
    }
    
    public init(start: CGPoint, end: CGPoint, mid: CGPoint, t: CGFloat = 0.5) {
        // shortcuts, although they're really dumb
        if t == 0 {
            self.init(p0: mid, p1: mid, p2: end)
        }
        else if t == 1 {
            self.init(p0: start, p1: mid, p2: mid)
        }
        else {
            // real fitting.
            let abc = Utils.getABC(n:2, S: start, B: mid, E: end, t: t)
            self.init(p0: start, p1: abc.A, p2: end)
        }
    }

    public var points: [CGPoint] {
        return [p0, p1, p2]
    }
    
    public var startingPoint: CGPoint {
        get {
            return p0
        }
        set(newValue) {
            p0 = newValue
        }
    }
    
    public var endingPoint: CGPoint {
        get {
            return p2
        }
        set(newValue) {
            p2 = newValue
        }
    }
    
    public var order: Int {
        return 2
    }
    
    public var simple: Bool {
        let n1 = self.normal(0)
        let n2 = self.normal(1)
        let s = Utils.clamp(n1.dot(n2), -1.0, 1.0)
        let angle: CGFloat = CGFloat(abs(acos(Double(s))))
        return angle < (CGFloat.pi / 3.0)
    }
    
    public func derivative(_ t: CGFloat) -> CGPoint {
        let mt: CGFloat = 1-t
        let k: CGFloat = 2
        let p0 = k * (self.p1 - self.p0)
        let p1 = k * (self.p2 - self.p1)
        let a = mt
        let b = t
        return a*p0 + b*p1
    }

    public func split(from t1: CGFloat, to t2: CGFloat) -> QuadraticBezierCurve {
    
        let h0 = self.p0
        let h1 = self.p1
        let h2 = self.p2
        let h3 = Utils.lerp(t1, h0, h1)
        let h4 = Utils.lerp(t1, h1, h2)
        let h5 = Utils.lerp(t1, h3, h4)
        
        let tr = Utils.map(t2, t1, 1, 0, 1)
        
        let i0 = h5
        let i1 = h4
        let i2 = h2
        let i3 = Utils.lerp(tr, i0, i1)
        let i4 = Utils.lerp(tr, i1, i2)
        let i5 = Utils.lerp(tr, i3, i4)
        
        return QuadraticBezierCurve(p0: i0, p1: i3, p2: i5)
    }

    public func split(at t: CGFloat) -> (left: QuadraticBezierCurve, right: QuadraticBezierCurve) {
        // use "de Casteljau" iteration.
        let h0 = self.p0
        let h1 = self.p1
        let h2 = self.p2
        let h3 = Utils.lerp(t, h0, h1)
        let h4 = Utils.lerp(t, h1, h2)
        let h5 = Utils.lerp(t, h3, h4)
        
        let leftCurve = QuadraticBezierCurve(p0: h0, p1: h3, p2: h5)
        let rightCurve = QuadraticBezierCurve(p0: h5, p1: h4, p2: h2)
    
        return (left: leftCurve, right: rightCurve)
    }

    public var boundingBox: BoundingBox {
        
        let p0: CGPoint = self.p0
        let p1: CGPoint = self.p1
        let p2: CGPoint = self.p2
        
        var mmin: CGPoint = CGPoint.min(p0, p2)
        var mmax: CGPoint = CGPoint.max(p0, p2)
        
        let d0: CGPoint = p1 - p0
        let d1: CGPoint = p2 - p1
        
        for d in 0..<CGPoint.dimensions {
            Utils.droots(d0[d], d1[d]) {(t: CGFloat) in
                if t <= 0.0 || t >= 1.0 {
                    return
                }

                // eval the curve
                // TODO: replacing this code with self.compute(t)[d] crashes in profile mode
                let mt = 1.0 - t
                let a = mt * mt
                let b = mt * t * 2.0
                let c = t * t
                let value = a * p0[d] + b * p1[d] + c * p2[d]
                
                if value < mmin[d] {
                    mmin[d] = value
                }
                else if value > mmax[d] {
                    mmax[d] = value
                }
            }
        }
        return BoundingBox(min: mmin, max: mmax)
    }

    public func compute(_ t: CGFloat) -> CGPoint {
        if t == 0 {
            return self.p0
        }
        else if t == 1 {
            return self.p2
        }
        let mt = 1.0 - t
        let mt2: CGFloat    = mt*mt
        let t2: CGFloat     = t*t
        let a = mt2
        let b = mt * t*2
        let c = t2
        // making the final sum one line of code makes XCode take forever to compiler! Hence the temporary variables.
        let temp1 = a * self.p0
        let temp2 = b * self.p1
        let temp3 = c * self.p2
        return temp1 + temp2 + temp3
    }
}

extension QuadraticBezierCurve: Transformable {
    public func copy(using t: CGAffineTransform) -> QuadraticBezierCurve {
        return QuadraticBezierCurve(p0: self.p0.applying(t), p1: self.p1.applying(t), p2: self.p2.applying(t))
    }
}

extension QuadraticBezierCurve: Reversible {
    public func reversed() -> QuadraticBezierCurve {
        return QuadraticBezierCurve(p0: self.p2, p1: self.p1, p2: self.p0)
    }
}

extension QuadraticBezierCurve: Flatness {
    public var flatnessSquared: CGFloat {
        let a: CGPoint = 2.0 * self.p1 - self.p0 - self.p2
        return (1.0 / 16.0) * (a.x * a.x + a.y * a.y)
    }
}
